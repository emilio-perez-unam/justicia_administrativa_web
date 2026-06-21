import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../domain/value_objects/password.dart';
import 'auth_repository.dart';

/// Validates the new password via [Password.create] then delegates to
/// [AuthRepository.updatePassword] to persist the change.
///
/// Validation error: [Err(ValidationFailure)] when the password is too short.
/// Infrastructure errors are propagated from the repository unchanged.
class ResetPasswordUseCase {
  final AuthRepository _repo;

  const ResetPasswordUseCase(this._repo);

  /// Validates [newPassword] then calls [AuthRepository.updatePassword].
  Future<Result<Unit>> call(String newPassword) async {
    final validation = Password.create(newPassword);
    if (validation.isErr) {
      // Propagate the ValidationFailure from the value object.
      return Err(
        validation.fold((_) => throw StateError('unreachable'), (f) => f),
      );
    }
    return _repo.updatePassword(newPassword.trim());
  }
}
