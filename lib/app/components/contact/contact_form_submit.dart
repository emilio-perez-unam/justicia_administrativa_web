// Contact-form submission orchestration, extracted from contact_form.dart so
// that file stays focused and under the 500-line ceiling (no monolithic files).
//
// Kept as an extension on the (library-private) state so it can read the form
// controllers/state directly. Note: methods here must NOT call State.setState
// (it is @protected — that lives in contact_form.dart); this orchestration only
// validates input, builds the domain entity, and delegates to the actor.

part of '../contact.dart';

extension _ContactFormSubmit on _ContactFormSectionState {
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_consultationType == null) {
      toastification.show(
        context: context,
        title: const Text('Error'),
        description: const Text('Seleccione un tipo de consulta'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    // Validate domain value objects and show inline toast on failure.
    final nameResult = PersonName.create(_nameController.text);
    if (nameResult.isErr) {
      _showValidationError(nameResult.fold((_) => '', (f) => f.message));
      return;
    }

    final emailResult = EmailAddress.create(_emailController.text);
    if (emailResult.isErr) {
      _showValidationError(emailResult.fold((_) => '', (f) => f.message));
      return;
    }

    final messageResult = ContactMessage.create(_messageController.text);
    if (messageResult.isErr) {
      _showValidationError(messageResult.fold((_) => '', (f) => f.message));
      return;
    }

    final inquiry = ContactInquiry(
      name: nameResult.valueOrNull!,
      email: emailResult.valueOrNull!,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      consultationType: _consultationType,
      preferredOffice: _preferredOffice,
      message: messageResult.valueOrNull!,
      isUrgent: _isUrgent,
      contactMethod: _contactMethod,
    );

    await _actor.submit(inquiry);
  }
}
