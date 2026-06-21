import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/auth/application/auth_repository.dart';
import 'package:justicia_administrativa_site/domains/auth/application/request_password_reset_use_case.dart';
import 'package:justicia_administrativa_site/domains/auth/application/reset_password_use_case.dart';
import 'package:justicia_administrativa_site/domains/auth/actors/password_recovery_actor.dart';

// ---------------------------------------------------------------------------
// Controllable fake repository — lets tests program the next result.
// ---------------------------------------------------------------------------
class _ControllableAuthRepository implements AuthRepository {
  late Result<Unit> Function(String email, String redirectTo) _resetHandler;
  late Result<Unit> Function(String pwd) _updateHandler;

  void willReturnForReset(Result<Unit> result) {
    _resetHandler = (_, __) => result;
  }

  void willReturnForUpdate(Result<Unit> result) {
    _updateHandler = (_) => result;
  }

  void willDelayReset(Result<Unit> result, Duration delay) {
    _resetHandler = (_, __) => result;
  }

  @override
  Future<Result<Unit>> requestPasswordReset(
    String email, {
    required String redirectTo,
  }) async => _resetHandler(email, redirectTo);

  @override
  Future<Result<Unit>> updatePassword(String newPassword) async =>
      _updateHandler(newPassword);
}

// ---------------------------------------------------------------------------
// Helpers for building actors under test.
// ---------------------------------------------------------------------------
PasswordRecoveryActor _buildActor(_ControllableAuthRepository repo) {
  final requestUseCase = RequestPasswordResetUseCase(repo);
  final resetUseCase = ResetPasswordUseCase(repo);
  return PasswordRecoveryActor(requestUseCase, resetUseCase);
}

// ---------------------------------------------------------------------------
// Tests.
// ---------------------------------------------------------------------------
void main() {
  const redirectTo = 'https://example.com/reset-password';

  late _ControllableAuthRepository repo;
  late PasswordRecoveryActor actor;

  setUp(() {
    repo = _ControllableAuthRepository();
    actor = _buildActor(repo);
  });

  tearDown(() => actor.dispose());

  // ── Initial state ──────────────────────────────────────────────────────────

  group('PasswordRecoveryActor — initial state', () {
    test('starts in idle phase', () {
      expect(actor.phase, PasswordRecoveryPhase.idle);
    });

    test('failure is null initially', () {
      expect(actor.failure, isNull);
    });
  });

  // ── requestReset ───────────────────────────────────────────────────────────

  group('PasswordRecoveryActor — requestReset success', () {
    test('transitions idle → sending → emailSent on success', () async {
      repo.willReturnForReset(Ok(unit));

      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.requestReset('user@example.com', redirectTo: redirectTo);

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.sending,
          PasswordRecoveryPhase.emailSent,
        ]),
      );
      expect(actor.phase, PasswordRecoveryPhase.emailSent);
    });

    test('failure is null after emailSent', () async {
      repo.willReturnForReset(Ok(unit));
      await actor.requestReset('user@example.com', redirectTo: redirectTo);
      expect(actor.failure, isNull);
    });
  });

  group('PasswordRecoveryActor — requestReset validation failure', () {
    test('transitions to error on invalid email', () async {
      // No need to program repo — use case will short-circuit.
      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.requestReset('not-an-email', redirectTo: redirectTo);

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.sending,
          PasswordRecoveryPhase.error,
        ]),
      );
      expect(actor.failure, isA<ValidationFailure>());
    });
  });

  group('PasswordRecoveryActor — requestReset infrastructure failure', () {
    test('transitions idle → sending → error on repo failure', () async {
      repo.willReturnForReset(const Err(NetworkFailure()));

      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.requestReset('user@example.com', redirectTo: redirectTo);

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.sending,
          PasswordRecoveryPhase.error,
        ]),
      );
      expect(actor.phase, PasswordRecoveryPhase.error);
      expect(actor.failure, isA<NetworkFailure>());
    });
  });

  // ── submitNewPassword ──────────────────────────────────────────────────────

  group('PasswordRecoveryActor — submitNewPassword success', () {
    test('transitions → updating → done on success', () async {
      repo.willReturnForUpdate(Ok(unit));

      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.submitNewPassword('newStrongPass1');

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.updating,
          PasswordRecoveryPhase.done,
        ]),
      );
      expect(actor.phase, PasswordRecoveryPhase.done);
    });

    test('failure is null after done', () async {
      repo.willReturnForUpdate(Ok(unit));
      await actor.submitNewPassword('newStrongPass1');
      expect(actor.failure, isNull);
    });
  });

  group('PasswordRecoveryActor — submitNewPassword validation failure', () {
    test('transitions to error for short password', () async {
      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.submitNewPassword('short');

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.updating,
          PasswordRecoveryPhase.error,
        ]),
      );
      expect(actor.failure, isA<ValidationFailure>());
    });
  });

  group('PasswordRecoveryActor — submitNewPassword infrastructure failure', () {
    test('transitions → updating → error on repo failure', () async {
      repo.willReturnForUpdate(const Err(AuthFailure()));

      final phases = <PasswordRecoveryPhase>[];
      actor.addListener(() => phases.add(actor.phase));

      await actor.submitNewPassword('validPassw0rd');

      expect(
        phases,
        containsAllInOrder([
          PasswordRecoveryPhase.updating,
          PasswordRecoveryPhase.error,
        ]),
      );
      expect(actor.failure, isA<AuthFailure>());
    });
  });

  // ── reset ──────────────────────────────────────────────────────────────────

  group('PasswordRecoveryActor — reset', () {
    test('resets to idle and clears failure', () async {
      repo.willReturnForReset(const Err(ServerFailure()));
      await actor.requestReset('user@example.com', redirectTo: redirectTo);

      actor.reset();

      expect(actor.phase, PasswordRecoveryPhase.idle);
      expect(actor.failure, isNull);
    });
  });
}
