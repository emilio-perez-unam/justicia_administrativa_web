import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import 'portal_settings_repository.dart';

/// Updates the current user's display name and phone number.
class UpdateProfileUseCase {
  final PortalSettingsRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Result<Unit>> call({
    required String displayName,
    required String phone,
  }) => _repository.updateProfile(displayName: displayName, phone: phone);
}
