import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import 'portal_settings_repository.dart';

/// Changes the current user's password.
///
/// The view enforces a minimum length of 6 characters before calling this
/// use case; this class delegates directly to the repository.
class ChangePasswordUseCase {
  final PortalSettingsRepository _repository;

  const ChangePasswordUseCase(this._repository);

  Future<Result<Unit>> call(String newPassword) =>
      _repository.changePassword(newPassword);
}
