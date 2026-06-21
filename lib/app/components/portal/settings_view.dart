import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domains/portal_settings/application/change_password_use_case.dart';
import '../../../domains/portal_settings/application/update_profile_use_case.dart';
import '../../router.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = AppRouter.authNotifier.currentUser;
    if (user != null) {
      _nameController.text = AppRouter.authNotifier.displayName;
      _phoneController.text = user.userMetadata?['phone'] ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await getIt<UpdateProfileUseCase>()(
      displayName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    result.fold(
      (_) => toastification.show(
        context: context,
        title: const Text('Perfil actualizado'),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      ),
      (failure) => toastification.show(
        context: context,
        title: const Text('Error al actualizar'),
        description: Text(failure.message),
        type: ToastificationType.error,
      ),
    );

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _showChangePasswordDialog() async {
    final passController = TextEditingController();
    if (!mounted) return;
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Cambiar Contraseña"),
        content: TextField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Nueva contraseña",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () async {
              if (passController.text.length < 6) {
                toastification.show(
                  context: dialogContext,
                  title: const Text("Mínimo 6 caracteres"),
                  type: ToastificationType.warning,
                );
                return;
              }
              Navigator.pop(dialogContext);

              final result = await getIt<ChangePasswordUseCase>()(
                passController.text,
              );

              if (!parentContext.mounted) return;

              result.fold(
                (_) => toastification.show(
                  context: parentContext,
                  title: const Text("Contraseña actualizada"),
                  type: ToastificationType.success,
                ),
                (failure) => toastification.show(
                  context: parentContext,
                  title: const Text("Error"),
                  description: Text(failure.message),
                  type: ToastificationType.error,
                ),
              );
            },
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Configuración",
          style: TextStyle(
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: navyColor,
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileSection(colors, navyColor),
                const SizedBox(height: 24),
                _buildSecuritySection(colors),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(dynamic colors, Color navyColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Perfil de Usuario",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navyColor,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: navyColor.withValues(alpha: 0.1),
                  child: Text(
                    AppRouter.authNotifier.displayName.isNotEmpty
                        ? AppRouter.authNotifier.displayName[0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navyColor,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Nombre completo",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: "Teléfono",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: FilledButton.styleFrom(backgroundColor: navyColor),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Guardar Cambios"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection(dynamic colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Seguridad",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(LucideIcons.lock),
            title: const Text("Contraseña"),
            subtitle: const Text("************"),
            trailing: OutlinedButton(
              onPressed: _showChangePasswordDialog,
              child: const Text("Cambiar"),
            ),
          ),
        ],
      ),
    );
  }
}
