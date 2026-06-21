import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';

/// Port that must be implemented by any infrastructure adapter that provides
/// Supabase password-recovery operations. Follows the DDD hexagonal pattern:
/// the port lives in the application layer; adapters live in infrastructure.
abstract class AuthRepository {
  /// Sends a password-reset email to [email] with a link pointing to
  /// [redirectTo].  Returns [Ok(unit)] on success, [Err] on failure.
  Future<Result<Unit>> requestPasswordReset(
    String email, {
    required String redirectTo,
  });

  /// Updates the currently-signed-in user's password to [newPassword].
  /// Must be called while a recovery session is active (i.e., after the user
  /// clicks the reset link and a `passwordRecovery` auth event fires).
  /// Returns [Ok(unit)] on success, [Err] on failure.
  Future<Result<Unit>> updatePassword(String newPassword);
}
