import 'dart:async' show TimeoutException;

import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException, StorageException;

import 'failure.dart';

/// Translates low-level exceptions into the sealed [Failure] hierarchy.
///
/// Rules (evaluated in order):
/// 1. If [error] is already a [Failure] it is returned unchanged.
/// 2. Supabase [AuthException] → [AuthFailure] with Spanish translation for
///    well-known messages, default [AuthFailure] for everything else.
/// 3. Supabase [PostgrestException] → [NotFoundFailure] (PGRST116),
///    [AuthFailure] (42501), or [ServerFailure] for other codes.
/// 4. Supabase [StorageException] → [ServerFailure].
/// 5. [TimeoutException] (dart:async) → [NetworkFailure].
/// 6. String-based network detection (web-safe, no dart:io) → [NetworkFailure].
/// 7. Everything else → [UnexpectedFailure].
///
/// The optional [stack] parameter is accepted but not stored — callers can
/// log it before delegating to this function.
Failure mapErrorToFailure(Object error, [StackTrace? stack]) {
  // 1 — passthrough: already a domain failure.
  if (error is Failure) return error;

  // 2 — Supabase auth failures.
  if (error is AuthException) return _mapAuthException(error);

  // 3 — Supabase PostgREST failures.
  if (error is PostgrestException) return _mapPostgrestException(error);

  // 4 — Supabase Storage failures.
  if (error is StorageException) {
    return ServerFailure(message: 'Error de almacenamiento.', cause: error);
  }

  // 5 — Async timeout (dart:async, web-safe).
  if (error is TimeoutException) {
    return NetworkFailure(cause: error);
  }

  // 6 — Generic network detection via string matching (web-safe — no dart:io).
  final errorString = error.toString().toLowerCase();
  if (_networkKeywords.any(errorString.contains)) {
    return NetworkFailure(cause: error);
  }

  // 7 — Catch-all.
  return UnexpectedFailure(cause: error);
}

// ────────────────────────────────────────────────────────────────────────────
// Private helpers
// ────────────────────────────────────────────────────────────────────────────

/// Lowercase substrings that indicate a network-level failure.
/// All comparisons are performed on `error.toString().toLowerCase()` so no
/// dart:io types are needed, which keeps the file web-safe.
const List<String> _networkKeywords = [
  'socketexception',
  'failed host lookup',
  'connection',
  'clientexception',
  'xmlhttprequest',
  'networkexception',
];

AuthFailure _mapAuthException(AuthException e) {
  final msg = e.message.toLowerCase();

  if (msg.contains('invalid login')) {
    return const AuthFailure(message: 'Correo o contraseña incorrectos.');
  }

  if (msg.contains('email not confirmed')) {
    return const AuthFailure(
      message: 'Debes confirmar tu correo antes de iniciar sesión.',
    );
  }

  // Default: session-expired / generic auth error.
  return AuthFailure(cause: e);
}

Failure _mapPostgrestException(PostgrestException e) {
  switch (e.code) {
    case 'PGRST116':
      return NotFoundFailure(cause: e);
    case '42501':
      return const AuthFailure(message: 'No tienes permiso para esta acción.');
    default:
      return ServerFailure(message: 'Error de datos: ${e.message}', cause: e);
  }
}
