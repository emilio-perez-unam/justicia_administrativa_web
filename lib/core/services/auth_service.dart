import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;
  final SupabaseClient _supabase;

  AuthService(this._storage, this._localAuth, this._supabase);

  // Secure Storage Keys
  static const String _tokenKey = 'auth_token';

  // --- Session Management ---

  Future<void> persistSession(Session session) async {
    if (session.accessToken.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: session.accessToken);
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _supabase.auth.signOut();
  }

  Future<String?> getPersistedToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // --- Biometrics ---

  Future<bool> get isBiometricsAvailable async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!await isBiometricsAvailable) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Por favor, autentícate para acceder a JusticIA',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // --- Jailbreak / Security Checks ---

  Future<bool> isDeviceSecure() async {
    // In a real scenario, use flutter_jailbreak_detection
    // For this implementation, we assume web/standard environment is safe enough for now
    // but this is where root detection logic would go.
    return true;
  }
}
