import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/auth/application/auth_repository.dart';
import 'package:justicia_administrativa_site/domains/auth/application/reset_password_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository.
// ---------------------------------------------------------------------------
class _FakeAuthRepository implements AuthRepository {
  Result<Unit>? _resetResult;
  Result<Unit>? _updateResult;

  String? capturedNewPassword;

  void willReturnForReset(Result<Unit> result) => _resetResult = result;
  void willReturnForUpdate(Result<Unit> result) => _updateResult = result;

  @override
  Future<Result<Unit>> requestPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    return _resetResult ?? Ok(unit);
  }

  @override
  Future<Result<Unit>> updatePassword(String newPassword) async {
    capturedNewPassword = newPassword;
    return _updateResult ?? Ok(unit);
  }
}

// ---------------------------------------------------------------------------
// Tests.
// ---------------------------------------------------------------------------
void main() {
  late _FakeAuthRepository fakeRepo;
  late ResetPasswordUseCase useCase;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
    useCase = ResetPasswordUseCase(fakeRepo);
  });

  group('ResetPasswordUseCase — password validation', () {
    test('returns ValidationFailure for an empty password', () async {
      final result = await useCase('');

      expect(result.isErr, isTrue);
      result.fold((_) => fail('Expected Err'), (f) {
        expect(f, isA<ValidationFailure>());
        expect(f.message, 'La contraseña debe tener al menos 8 caracteres.');
      });
    });

    test(
      'returns ValidationFailure for a password shorter than 8 chars',
      () async {
        final result = await useCase('short');

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('Expected Err'),
          (f) => expect(f, isA<ValidationFailure>()),
        );
      },
    );

    test('does not call the repository when password is invalid', () async {
      await useCase('tiny');

      expect(fakeRepo.capturedNewPassword, isNull);
    });
  });

  group('ResetPasswordUseCase — happy path', () {
    test('delegates to repository with trimmed password', () async {
      fakeRepo.willReturnForUpdate(Ok(unit));

      final result = await useCase('  strongPass1  ');

      expect(result.isOk, isTrue);
      expect(fakeRepo.capturedNewPassword, 'strongPass1');
    });

    test('returns Ok(unit) when repository succeeds', () async {
      fakeRepo.willReturnForUpdate(Ok(unit));

      final result = await useCase('validPassw0rd');

      expect(result.isOk, isTrue);
    });
  });

  group('ResetPasswordUseCase — failure path', () {
    test('propagates AuthFailure from repository', () async {
      fakeRepo.willReturnForUpdate(const Err(AuthFailure()));

      final result = await useCase('validPassw0rd');

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<AuthFailure>()),
      );
    });

    test('propagates NetworkFailure from repository', () async {
      fakeRepo.willReturnForUpdate(const Err(NetworkFailure()));

      final result = await useCase('validPassw0rd');

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });
  });
}
