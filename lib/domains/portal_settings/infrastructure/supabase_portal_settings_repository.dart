import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../application/portal_settings_repository.dart';

/// Supabase-backed implementation.
///
/// Both operations delegate to `Supabase.instance.client.auth.updateUser`,
/// which is exactly what [SettingsView] called inline before this refactor.
class SupabasePortalSettingsRepository implements PortalSettingsRepository {
  const SupabasePortalSettingsRepository();

  @override
  Future<Result<Unit>> updateProfile({
    required String displayName,
    required String phone,
  }) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'full_name': displayName, 'phone': phone}),
      );
      return Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<Unit>> changePassword(String newPassword) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
