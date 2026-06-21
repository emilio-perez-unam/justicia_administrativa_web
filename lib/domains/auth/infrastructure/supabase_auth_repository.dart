import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../application/auth_repository.dart';

/// Supabase adapter for [AuthRepository].
///
/// Uses GoTrue (via `supabase_flutter`) to send password-reset emails and to
/// update the user's password during an active recovery session.
/// All exceptions are mapped to domain [Failure]s via [mapErrorToFailure].
class SupabaseAuthRepository implements AuthRepository {
  /// The Supabase client.  Defaults to [Supabase.instance.client] so that the
  /// constructor can be called with no arguments in production while still
  /// accepting an injected client in tests.
  final SupabaseClient _client;

  SupabaseAuthRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<Result<Unit>> requestPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
      return Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<Unit>> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      return Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
