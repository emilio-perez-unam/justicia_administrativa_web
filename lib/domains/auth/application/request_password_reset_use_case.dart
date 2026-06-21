import 'package:email_validator/email_validator.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import 'auth_repository.dart';

/// Validates the email address then delegates to [AuthRepository] to send a
/// password-reset link to the user.
///
/// Validation error: [Err(ValidationFailure)] when the email is invalid.
/// Infrastructure errors are propagated from the repository unchanged.
class RequestPasswordResetUseCase {
  final AuthRepository _repo;

  const RequestPasswordResetUseCase(this._repo);

  /// Validates [email], then calls [AuthRepository.requestPasswordReset].
  ///
  /// [redirectTo] is threaded through to the repository so the reset email
  /// links the user back to the correct URL (e.g. EnvConfig.passwordResetRedirect).
  Future<Result<Unit>> call(String email, {required String redirectTo}) async {
    final trimmed = email.trim();
    if (!EmailValidator.validate(trimmed)) {
      return const Err(ValidationFailure('Ingrese un correo válido.'));
    }
    return _repo.requestPasswordReset(trimmed, redirectTo: redirectTo);
  }
}
