import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/error/unit.dart';
import 'package:justicia_administrativa_site/domains/portal_settings/application/portal_settings_repository.dart';
import 'package:justicia_administrativa_site/domains/portal_settings/application/update_profile_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeRepo implements PortalSettingsRepository {
  Result<Unit>? updateProfileResult;

  String? lastDisplayName;
  String? lastPhone;

  _FakeRepo({this.updateProfileResult});

  @override
  Future<Result<Unit>> updateProfile({
    required String displayName,
    required String phone,
  }) async {
    lastDisplayName = displayName;
    lastPhone = phone;
    return updateProfileResult ?? Ok(unit);
  }

  @override
  Future<Result<Unit>> changePassword(String newPassword) async => Ok(unit);
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UpdateProfileUseCase', () {
    test('delegates to repository with correct arguments on success', () async {
      final repo = _FakeRepo(updateProfileResult: Ok(unit));
      final useCase = UpdateProfileUseCase(repo);

      final result = await useCase(
        displayName: 'Ana López',
        phone: '5551234567',
      );

      expect(result.isOk, isTrue);
      expect(repo.lastDisplayName, equals('Ana López'));
      expect(repo.lastPhone, equals('5551234567'));
    });

    test('returns Ok(unit) when repository succeeds', () async {
      final useCase = UpdateProfileUseCase(_FakeRepo());

      final result = await useCase(displayName: 'Test', phone: '');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isA<Unit>());
    });

    test(
      'returns Err(AuthFailure) when repository fails with auth error',
      () async {
        const failure = AuthFailure();
        final repo = _FakeRepo(updateProfileResult: Err<Unit>(failure));
        final useCase = UpdateProfileUseCase(repo);

        final result = await useCase(displayName: 'Ana', phone: '');

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('expected Err'),
          (f) => expect(f, isA<AuthFailure>()),
        );
      },
    );

    test(
      'returns Err(NetworkFailure) when repository fails with network error',
      () async {
        const failure = NetworkFailure();
        final repo = _FakeRepo(updateProfileResult: Err<Unit>(failure));
        final useCase = UpdateProfileUseCase(repo);

        final result = await useCase(displayName: 'Ana', phone: '');

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('expected Err'),
          (f) => expect(f, isA<NetworkFailure>()),
        );
      },
    );
  });
}
