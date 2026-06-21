import 'dart:async' show TimeoutException;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException, StorageException;

import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/failure_mapper.dart';

void main() {
  group('mapErrorToFailure — passthrough', () {
    test('returns an existing Failure unchanged', () {
      const f = NetworkFailure();
      expect(mapErrorToFailure(f), same(f));
    });

    test('returns a ServerFailure unchanged', () {
      const f = ServerFailure();
      expect(mapErrorToFailure(f), same(f));
    });
  });

  group('mapErrorToFailure — dart:async TimeoutException', () {
    test('TimeoutException maps to NetworkFailure', () {
      expect(
        mapErrorToFailure(TimeoutException('timeout')),
        isA<NetworkFailure>(),
      );
    });

    test('TimeoutException with null message maps to NetworkFailure', () {
      expect(mapErrorToFailure(TimeoutException(null)), isA<NetworkFailure>());
    });
  });

  group('mapErrorToFailure — generic network string detection', () {
    test('error.toString() containing "SocketException" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('SocketException: OS Error')),
        isA<NetworkFailure>(),
      );
    });

    test('"Failed host lookup" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('Failed host lookup: api.example.com')),
        isA<NetworkFailure>(),
      );
    });

    test('"Connection refused" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('Connection refused')),
        isA<NetworkFailure>(),
      );
    });

    test('"ClientException" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('ClientException: bad response')),
        isA<NetworkFailure>(),
      );
    });

    test('"XMLHttpRequest" → NetworkFailure (web)', () {
      expect(
        mapErrorToFailure(Exception('XMLHttpRequest error')),
        isA<NetworkFailure>(),
      );
    });

    test('"NetworkException" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('NetworkException: disconnected')),
        isA<NetworkFailure>(),
      );
    });

    test('case-insensitive: "socketexception" → NetworkFailure', () {
      expect(
        mapErrorToFailure(Exception('socketexception lowercased')),
        isA<NetworkFailure>(),
      );
    });
  });

  group('mapErrorToFailure — unknown error', () {
    test('StateError maps to UnexpectedFailure', () {
      expect(mapErrorToFailure(StateError('boom')), isA<UnexpectedFailure>());
    });

    test('generic Exception maps to UnexpectedFailure', () {
      expect(
        mapErrorToFailure(Exception('something weird')),
        isA<UnexpectedFailure>(),
      );
    });

    test('String error maps to UnexpectedFailure', () {
      expect(mapErrorToFailure('raw string error'), isA<UnexpectedFailure>());
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Supabase exception types
  // Note: AuthException(message) — positional first arg confirmed from
  // gotrue-2.18.0/lib/src/types/auth_exception.dart:
  //   const AuthException(this.message, {this.statusCode, this.code});
  // ──────────────────────────────────────────────────────────────────────────
  group('mapErrorToFailure — AuthException', () {
    test('AuthException("Invalid login credentials") → AuthFailure', () {
      expect(
        mapErrorToFailure(const AuthException('Invalid login credentials')),
        isA<AuthFailure>(),
      );
    });

    test('AuthFailure message is translated for "invalid login"', () {
      final f =
          mapErrorToFailure(const AuthException('Invalid login credentials'))
              as AuthFailure;
      expect(f.message, 'Correo o contraseña incorrectos.');
    });

    test('AuthException("email not confirmed") → AuthFailure', () {
      expect(
        mapErrorToFailure(const AuthException('email not confirmed')),
        isA<AuthFailure>(),
      );
    });

    test('AuthFailure message is translated for "email not confirmed"', () {
      final f =
          mapErrorToFailure(const AuthException('email not confirmed'))
              as AuthFailure;
      expect(f.message, 'Debes confirmar tu correo antes de iniciar sesión.');
    });

    test('unknown AuthException → AuthFailure with default message', () {
      final f =
          mapErrorToFailure(const AuthException('some unknown auth error'))
              as AuthFailure;
      expect(f, isA<AuthFailure>());
    });
  });

  group('mapErrorToFailure — PostgrestException', () {
    test('PGRST116 → NotFoundFailure', () {
      expect(
        mapErrorToFailure(
          const PostgrestException(message: 'not found', code: 'PGRST116'),
        ),
        isA<NotFoundFailure>(),
      );
    });

    test('42501 → AuthFailure (no permission)', () {
      final f = mapErrorToFailure(
        const PostgrestException(message: 'permission denied', code: '42501'),
      );
      expect(f, isA<AuthFailure>());
      expect((f as AuthFailure).message, 'No tienes permiso para esta acción.');
    });

    test('other code → ServerFailure with message prefix', () {
      final f = mapErrorToFailure(
        const PostgrestException(message: 'db error', code: '23505'),
      );
      expect(f, isA<ServerFailure>());
      expect((f as ServerFailure).message, contains('db error'));
    });

    test('null code → ServerFailure', () {
      final f = mapErrorToFailure(
        const PostgrestException(message: 'generic db error'),
      );
      expect(f, isA<ServerFailure>());
    });
  });

  group('mapErrorToFailure — StorageException', () {
    test('StorageException → ServerFailure', () {
      expect(
        mapErrorToFailure(const StorageException('storage error')),
        isA<ServerFailure>(),
      );
    });

    test('StorageException message mentions "almacenamiento"', () {
      final f =
          mapErrorToFailure(const StorageException('bucket not found'))
              as ServerFailure;
      expect(f.message, contains('almacenamiento'));
    });
  });

  group('mapErrorToFailure — cause is preserved', () {
    test('TimeoutException cause is the original error', () {
      final e = TimeoutException('slow');
      final f = mapErrorToFailure(e) as NetworkFailure;
      expect(f.cause, same(e));
    });

    test('StateError cause is preserved in UnexpectedFailure', () {
      final e = StateError('crash');
      final f = mapErrorToFailure(e) as UnexpectedFailure;
      expect(f.cause, same(e));
    });
  });
}
