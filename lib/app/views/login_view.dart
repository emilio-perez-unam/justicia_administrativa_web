import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:toastification/toastification.dart';

import '../../core/config/env_config.dart';
import '../../core/di/dependency_injection.dart';
import '../../domains/auth/actors/password_recovery_actor.dart';
import '../../domains/auth/application/request_password_reset_use_case.dart';
import '../../domains/auth/application/reset_password_use_case.dart';
import '../router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isLoading = false;
  bool _obscurePassword = true;

  final form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });

  /// Actor for the forgot-password flow — created lazily and disposed here.
  PasswordRecoveryActor? _recoveryActor;

  @override
  void dispose() {
    _recoveryActor?.dispose();
    super.dispose();
  }

  PasswordRecoveryActor _ensureActor() {
    return _recoveryActor ??= PasswordRecoveryActor(
      getIt<RequestPasswordResetUseCase>(),
      getIt<ResetPasswordUseCase>(),
    );
  }

  Future<void> _handleLogin() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = form.control('email').value as String;
      final password = form.control('password').value as String;

      await AppRouter.authNotifier.login(email, password);
      // Navigation is handled by router redirect
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Error de inicio de sesión'),
          description: Text(e.toString()),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog where the user enters their email, then calls
  /// [PasswordRecoveryActor.requestReset] to send a recovery email.
  Future<void> _handleForgotPassword() async {
    final emailController = TextEditingController();
    final actor = _ensureActor();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return ListenableBuilder(
          listenable: actor,
          builder: (_, __) {
            final isSending = actor.phase == PasswordRecoveryPhase.sending;

            return AlertDialog(
              title: const Text('Recuperar contraseña'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isSending,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(LucideIcons.mail),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => isSending
                        ? null
                        : _submitRecovery(emailController, actor, dialogCtx),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: isSending
                      ? null
                      : () =>
                            _submitRecovery(emailController, actor, dialogCtx),
                  child: isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Enviar enlace'),
                ),
              ],
            );
          },
        );
      },
    );

    emailController.dispose();
    // Reset actor after the dialog is dismissed so it is ready for re-use.
    actor.reset();
  }

  Future<void> _submitRecovery(
    TextEditingController emailCtrl,
    PasswordRecoveryActor actor,
    BuildContext dialogCtx,
  ) async {
    await actor.requestReset(
      emailCtrl.text,
      redirectTo: EnvConfig.passwordResetRedirect,
    );

    if (!dialogCtx.mounted) return;

    if (actor.phase == PasswordRecoveryPhase.emailSent) {
      Navigator.of(dialogCtx).pop();
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Enlace enviado'),
          description: const Text(
            'Te enviamos un enlace para restablecer tu contraseña.',
          ),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } else if (actor.phase == PasswordRecoveryPhase.error) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Error'),
          description: Text(actor.failure?.message ?? 'Error desconocido.'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Panel (Branding)
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF1E3A8A),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.scale,
                      size: 64,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "JusticIAdministrativa",
                    style: TextStyle(
                      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      "Plataforma inteligente de gestión legal y análisis jurídico avanzado.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Panel (Form)
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                padding: const EdgeInsets.all(48),
                child: ReactiveForm(
                  formGroup: form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Bienvenido",
                        style: TextStyle(
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ingresa a tu cuenta para continuar",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 48),

                      // Email
                      ReactiveTextField(
                        formControlName: 'email',
                        decoration: const InputDecoration(
                          labelText: "Correo Electrónico",
                          prefixIcon: Icon(LucideIcons.mail),
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'El correo es requerido',
                          ValidationMessage.email: (_) =>
                              'Ingrese un correo válido',
                        },
                      ),
                      const SizedBox(height: 24),

                      // Password
                      ReactiveTextField(
                        formControlName: 'password',
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: const Icon(LucideIcons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                              'La contraseña es requerida',
                          ValidationMessage.minLength: (_) =>
                              'Mínimo 6 caracteres',
                        },
                        onSubmitted: (_) => _handleLogin(),
                      ),

                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword,
                          child: const Text("¿Olvidaste tu contraseña?"),
                        ),
                      ),

                      const SizedBox(height: 32),

                      FilledButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("INICIAR SESIÓN"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
