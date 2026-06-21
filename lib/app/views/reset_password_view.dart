import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../core/di/dependency_injection.dart';
import '../../domains/auth/actors/password_recovery_actor.dart';
import '../../domains/auth/application/request_password_reset_use_case.dart';
import '../../domains/auth/application/reset_password_use_case.dart';
import '../router.dart';

/// Route screen for completing a Supabase password-recovery flow on web.
///
/// Lifecycle:
/// 1. In [initState], subscribe to [GoTrueClient.onAuthStateChange].
/// 2. If the URL fragment contains `type=recovery`, Supabase fires
///    [AuthChangeEvent.passwordRecovery] — set [_hasRecoverySession] = true.
/// 3. While [_hasRecoverySession] is true, render the new-password form.
/// 4. On submit, call [PasswordRecoveryActor.submitNewPassword]; on [done]
///    navigate to `/portal`.
/// 5. If the user arrives without a recovery session, show a friendly error
///    with a link back to `/login`.
class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  // ── state ──────────────────────────────────────────────────────────────────

  bool _hasRecoverySession = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  late final PasswordRecoveryActor _actor;
  StreamSubscription<AuthState>? _authSub;

  // ── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _actor = PasswordRecoveryActor(
      getIt<RequestPasswordResetUseCase>(),
      getIt<ResetPasswordUseCase>(),
    );
    _actor.addListener(_onActorChange);

    // Listen for the passwordRecovery auth event emitted when Supabase detects
    // the #access_token=...&type=recovery fragment in the URL on web.
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((
      authState,
    ) {
      if (!mounted) return;
      if (authState.event == AuthChangeEvent.passwordRecovery) {
        setState(() => _hasRecoverySession = true);
      }
    });

    // Also check if a session is already present (e.g. page refreshed after
    // the fragment was processed).
    final currentSession = Supabase.instance.client.auth.currentSession;
    if (currentSession != null) {
      // The fragment was already consumed and a session was established before
      // this widget mounted; treat it as a recovery context.
      _hasRecoverySession = true;
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _actor.removeListener(_onActorChange);
    _actor.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── actor listener ─────────────────────────────────────────────────────────

  void _onActorChange() {
    if (!mounted) return;
    setState(() {});

    if (_actor.phase == PasswordRecoveryPhase.done) {
      toastification.show(
        context: context,
        title: const Text('Contraseña actualizada'),
        description: const Text(
          'Tu contraseña fue actualizada exitosamente. Bienvenido.',
        ),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 4),
      );
      context.go(AppRouter.portal);
    }
  }

  // ── submit ─────────────────────────────────────────────────────────────────

  Future<void> _handleSubmit() async {
    final pwd = _passwordController.text;
    final confirm = _confirmController.text;

    if (pwd.trim().isEmpty || confirm.trim().isEmpty) {
      toastification.show(
        context: context,
        title: const Text('Campos requeridos'),
        description: const Text('Por favor completa ambos campos.'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (pwd != confirm) {
      toastification.show(
        context: context,
        title: const Text('Las contraseñas no coinciden'),
        description: const Text('Verifica que ambas contraseñas sean iguales.'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    await _actor.submitNewPassword(pwd);

    // Error toast is shown reactively by _onActorChange → but for the
    // validation / server error case we also show it here for immediacy.
    if (mounted && _actor.phase == PasswordRecoveryPhase.error) {
      toastification.show(
        context: context,
        title: const Text('Error al actualizar contraseña'),
        description: Text(_actor.failure?.message ?? 'Error desconocido.'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(48),
            child: _hasRecoverySession ? _buildForm() : _buildNoSession(),
          ),
        ),
      ),
    );
  }

  // ── form (recovery session active) ─────────────────────────────────────────

  Widget _buildForm() {
    final isUpdating = _actor.phase == PasswordRecoveryPhase.updating;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            LucideIcons.keyRound,
            size: 48,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          'Nueva contraseña',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Elige una contraseña segura de al menos 8 caracteres.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 40),

        // Password field
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !isUpdating,
          decoration: InputDecoration(
            labelText: 'Nueva contraseña',
            prefixIcon: const Icon(LucideIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // Confirm field
        TextField(
          controller: _confirmController,
          obscureText: _obscureConfirm,
          enabled: !isUpdating,
          decoration: InputDecoration(
            labelText: 'Confirmar contraseña',
            prefixIcon: const Icon(LucideIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? LucideIcons.eye : LucideIcons.eyeOff,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => isUpdating ? null : _handleSubmit(),
        ),
        const SizedBox(height: 32),

        // Submit button
        FilledButton(
          onPressed: isUpdating ? null : _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: isUpdating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('ACTUALIZAR CONTRASEÑA'),
        ),
        const SizedBox(height: 16),

        // Cancel / back to login
        TextButton(
          onPressed: () => context.go(AppRouter.login),
          child: const Text('Volver al inicio de sesión'),
        ),
      ],
    );
  }

  // ── no-session screen ──────────────────────────────────────────────────────

  Widget _buildNoSession() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            LucideIcons.alertTriangle,
            size: 48,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Enlace inválido o expirado',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'El enlace para restablecer tu contraseña no es válido o ya expiró. '
          'Solicita un nuevo enlace desde la pantalla de inicio de sesión.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
        ),
        const SizedBox(height: 40),

        FilledButton(
          onPressed: () => context.go(AppRouter.login),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('IR AL INICIO DE SESIÓN'),
        ),
      ],
    );
  }
}
