// Provides contact-form field widgets and validators.

part of '../contact.dart';

/// Themed text input field for the contact form.
///
/// Accepts an optional [controller] so the parent can capture the field value.
/// Without a controller the field still validates but does not expose its text
/// externally — always pass a controller for fields whose value must be read.
class _TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool required;
  final bool isEmail;
  final int maxLines;

  /// Optional controller — pass one from the parent State to capture the value.
  final TextEditingController? controller;

  const _TextInput({
    required this.label,
    required this.hint,
    this.required = false,
    this.isEmail = false,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.mutedForeground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: colors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return "Este campo es requerido";
            }
            if (isEmail &&
                value != null &&
                value.isNotEmpty &&
                !value.contains('@')) {
              return "Ingrese un correo válido";
            }
            return null;
          },
        ),
      ],
    );
  }
}
