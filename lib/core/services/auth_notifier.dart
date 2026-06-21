import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';

class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  AuthNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  bool get isAuthenticated =>
      Supabase.instance.client.auth.currentSession != null;

  User? get currentUser => Supabase.instance.client.auth.currentUser;

  String get displayName {
    final user = currentUser;
    if (user == null) return '';
    final meta = user.userMetadata;
    if (meta != null && meta['full_name'] != null) {
      final name = meta['full_name'] as String;
      if (name.isNotEmpty) return name;
    }
    return user.email?.split('@').first ?? '';
  }

  String get email => currentUser?.email ?? '';

  UserRole get role =>
      UserRole.fromString(currentUser?.userMetadata?['role'] as String?);

  bool get isAdmin => role.isAdmin;

  bool get isTeamOrAbove => role.isTeamOrAbove;

  Future<void> login(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session == null) {
      throw const AuthException('Error de inicio de sesión');
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
