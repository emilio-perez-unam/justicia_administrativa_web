// Dialog for a client to open (request) a new matter.

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/services/portal_service.dart';

/// Form dialog that creates a new matter for the current client.
///
/// Pops `true` when a matter was created so the caller can refresh the list.
class NewMatterDialog extends StatefulWidget {
  const NewMatterDialog({super.key});

  @override
  State<NewMatterDialog> createState() => _NewMatterDialogState();
}

class _NewMatterDialogState extends State<NewMatterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  MatterType _type = MatterType.consulta;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await PortalService.createMatter(
        title: _titleController.text.trim(),
        matterType: _type.dbValue,
        subtitle: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      toastification.show(
        context: context,
        title: const Text('No se pudo crear el asunto'),
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo asunto'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. Amparo contra multa administrativa',
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingrese un título' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MatterType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: [
                for (final t in MatterType.values)
                  DropdownMenuItem(value: t, child: Text(t.displayName)),
              ],
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Crear'),
        ),
      ],
    );
  }
}
