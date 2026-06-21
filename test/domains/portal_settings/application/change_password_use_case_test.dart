import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/portal_settings/application/change_password_use_case.dart';
import 'package:justicia_administrativa_site/domains/portal_settings/application/portal_settings_repository.dart';

// ---------------------------------------------------------------------------
// Fake repository (reuse shape from update_profile test file)
// ---------------------------------------------------------------------------

class _FakeRepo implements PortalSettingsRepository {
  final Result<Unit> result;
  String? capturedPassword;

  _FakeRepo(this.result);

  @override
  Future<Result<Unit>> updateProfile({
    required String displayName,
    required String phone,
  }) async => Ok(unit);

  @override
  Future<Result<Unit>> changePassword(String newPassword) async {
    capturedPassword = newPassword;
    return result;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ChangePasswordUseCase', () {
    test('delegates new password to repository', () async {
      final repo = _FakeRepo(Ok(unit));
      final useCase = ChangePasswordUseCase(repo);

      await useCase('nuev4Pass!');

      expect(repo.capturedPassword, equals('nuev4Pass!'));
    });

    test('returns Ok(unit) on success', () async {
      final useCase = ChangePasswordUseCase(_FakeRepo(Ok(unit)));

      final result = await useCase('newPassword123');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isA<Unit>());
    });

    test('returns Err(AuthFailure) when repository fails', () async {
      const failure = AuthFailure(message: 'Sesión expirada.');
      final useCase = ChangePasswordUseCase(_FakeRepo(Err<Unit>(failure)));

      final result = await useCase('newPassword123');

      expect(result.isErr, isTrue);
      result.fold((_) => fail('expected Err'), (f) {
        expect(f, isA<AuthFailure>());
        expect(f.message, equals('Sesión expirada.'));
      });
    });

    test('returns Err(ServerFailure) on server error', () async {
      const failure = ServerFailure();
      final useCase = ChangePasswordUseCase(_FakeRepo(Err<Unit>(failure)));

      final result = await useCase('newPassword123');

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<ServerFailure>()),
      );
    });
  });
}
