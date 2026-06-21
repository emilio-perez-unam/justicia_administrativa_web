import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';

/// Port for the portal-settings domain.
///
/// Covers the two write operations that [SettingsView] performs:
///   1. Update user profile metadata (display name, phone).
///   2. Change the authenticated user's password.
///
/// Implementations delegate to Supabase Auth (`auth.updateUser`).
abstract class PortalSettingsRepository {
  /// Updates the current user's profile metadata.
  ///
  /// [displayName] maps to `user_metadata['full_name']`.
  /// [phone] maps to `user_metadata['phone']`.
  Future<Result<Unit>> updateProfile({
    required String displayName,
    required String phone,
  });

  /// Changes the current user's password.
  ///
  /// [newPassword] must be at least 6 characters (validated by the caller).
  Future<Result<Unit>> changePassword(String newPassword);
}
