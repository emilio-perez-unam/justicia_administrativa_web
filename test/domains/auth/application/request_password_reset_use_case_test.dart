import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/auth/application/auth_repository.dart';
import 'package:justicia_administrativa_site/domains/auth/application/request_password_reset_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository.
// ---------------------------------------------------------------------------
class _FakeAuthRepository implements AuthRepository {
  Result<Unit>? _resetResult;
  Result<Unit>? _updateResult;

  String? capturedEmail;
  String? capturedRedirectTo;

  void willReturnForReset(Result<Unit> result) => _resetResult = result;
  void willReturnForUpdate(Result<Unit> result) => _updateResult = result;

  @override
  Future<Result<Unit>> requestPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    capturedEmail = email;
    capturedRedirectTo = redirectTo;
    return _resetResult ?? Ok(unit);
  }

  @override
  Future<Result<Unit>> updatePassword(String newPassword) async {
    return _updateResult ?? Ok(unit);
  }
}

// ---------------------------------------------------------------------------
// Tests.
// ---------------------------------------------------------------------------
void main() {
  const redirectTo = 'https://example.com/reset-password';

  late _FakeAuthRepository fakeRepo;
  late RequestPasswordResetUseCase useCase;

  setUp(() {
    fakeRepo = _FakeAuthRepository();
    useCase = RequestPasswordResetUseCase(fakeRepo);
  });

  group('RequestPasswordResetUseCase — email validation', () {
    test('returns ValidationFailure for an empty email', () async {
      final result = await useCase('', redirectTo: redirectTo);

      expect(result.isErr, isTrue);
      result.fold((_) => fail('Expected Err'), (f) {
        expect(f, isA<ValidationFailure>());
        expect(f.message, 'Ingrese un correo válido.');
      });
    });

    test('returns ValidationFailure for a malformed email', () async {
      final result = await useCase('not-an-email', redirectTo: redirectTo);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<ValidationFailure>()),
      );
    });

    test('does not call the repository when email is invalid', () async {
      await useCase('bad@@email', redirectTo: redirectTo);

      expect(fakeRepo.capturedEmail, isNull);
    });
  });

  group('RequestPasswordResetUseCase — happy path', () {
    test('delegates to repository with trimmed email and redirectTo', () async {
      fakeRepo.willReturnForReset(Ok(unit));

      final result = await useCase(
        '  user@example.com  ',
        redirectTo: redirectTo,
      );

      expect(result.isOk, isTrue);
      expect(fakeRepo.capturedEmail, 'user@example.com');
      expect(fakeRepo.capturedRedirectTo, redirectTo);
    });

    test('returns Ok(unit) when repository succeeds', () async {
      fakeRepo.willReturnForReset(Ok(unit));

      final result = await useCase('user@example.com', redirectTo: redirectTo);

      expect(result.isOk, isTrue);
    });
  });

  group('RequestPasswordResetUseCase — failure path', () {
    test('propagates NetworkFailure from repository', () async {
      fakeRepo.willReturnForReset(const Err(NetworkFailure()));

      final result = await useCase('user@example.com', redirectTo: redirectTo);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });

    test('propagates ServerFailure from repository', () async {
      fakeRepo.willReturnForReset(const Err(ServerFailure()));

      final result = await useCase('user@example.com', redirectTo: redirectTo);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });
  });
}
