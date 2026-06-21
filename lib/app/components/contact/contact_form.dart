// Owns contact inquiry form state, validation, and submission via DDD actor.

part of '../contact.dart';

class _ContactFormSection extends StatefulWidget {
  const _ContactFormSection();

  @override
  State<_ContactFormSection> createState() => _ContactFormSectionState();
}

class _ContactFormSectionState extends State<_ContactFormSection> {
  // ── Form key ────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Field controllers ────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();

  // ── Non-text field state ─────────────────────────────────────────────────
  String? _consultationType;
  String? _preferredOffice;
  String _contactMethod = 'email';
  bool _isUrgent = false;

  /// Incremented on reset so the dropdown gets a new key and reinitialises.
  int _dropdownResetCounter = 0;

  // ── Actor ────────────────────────────────────────────────────────────────
  late final ContactFormActor _actor;

  @override
  void initState() {
    super.initState();
    _actor = ContactFormActor(getIt<SubmitContactInquiryUseCase>());
    _actor.addListener(_onActorChanged);
  }

  @override
  void dispose() {
    _actor.removeListener(_onActorChanged);
    _actor.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ── Actor listener ───────────────────────────────────────────────────────

  void _onActorChanged() {
    if (!mounted) return;
    setState(() {}); // rebuild to reflect new status

    if (_actor.status == ContactFormStatus.success) {
      toastification.show(
        context: context,
        title: const Text('Mensaje enviado'),
        description: const Text('Nuestro equipo legal le contactará en breve.'),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 5),
      );
      _resetForm();
    } else if (_actor.status == ContactFormStatus.error) {
      final message =
          _actor.failure?.message ?? 'Ocurrió un error al enviar el mensaje.';
      toastification.show(
        context: context,
        title: const Text('Error al enviar'),
        description: Text(message),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  // ── Submission ───────────────────────────────────────────────────────────
  // _submit() is defined in contact_form_submit.dart (part) to keep this file
  // focused and under the 500-line ceiling.

  void _showValidationError(String message) {
    toastification.show(
      context: context,
      title: const Text('Datos incompletos'),
      description: Text(message),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _companyController.clear();
    _messageController.clear();
    setState(() {
      _consultationType = null;
      _preferredOffice = null;
      _contactMethod = 'email';
      _isUrgent = false;
      _dropdownResetCounter++;
    });
    _actor.reset();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get _isSubmitting => _actor.status == ContactFormStatus.submitting;

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);

    return SectionContainer(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(colors.radiusXl),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contáctenos",
                    style: TextStyle(
                      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: navyColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: colors.border),
                  const SizedBox(height: 32),

                  // ── Name / Email row ──────────────────────────────────
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 600;
                      return Column(
                        children: [
                          Flex(
                            direction: isDesktop
                                ? Axis.horizontal
                                : Axis.vertical,
                            children: [
                              Expanded(
                                child: _TextInput(
                                  label: "Nombre completo *",
                                  hint: "Ingrese su nombre",
                                  required: true,
                                  controller: _nameController,
                                ),
                              ),
                              SizedBox(
                                width: isDesktop ? 24 : 0,
                                height: isDesktop ? 0 : 24,
                              ),
                              Expanded(
                                child: _TextInput(
                                  label: "Correo electrónico *",
                                  hint: "correo@ejemplo.com",
                                  required: true,
                                  isEmail: true,
                                  controller: _emailController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ── Phone / Company row ───────────────────────
                          Flex(
                            direction: isDesktop
                                ? Axis.horizontal
                                : Axis.vertical,
                            children: [
                              Expanded(
                                child: _TextInput(
                                  label: "Teléfono",
                                  hint: "+52 (55) 1234-5678",
                                  controller: _phoneController,
                                ),
                              ),
                              SizedBox(
                                width: isDesktop ? 24 : 0,
                                height: isDesktop ? 0 : 24,
                              ),
                              Expanded(
                                child: _TextInput(
                                  label: "Empresa",
                                  hint: "Nombre de su empresa",
                                  controller: _companyController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Consultation type ─────────────────────────────────
                  Text(
                    "Tipo de consulta *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadioGroup<String>(
                    groupValue: _consultationType,
                    onChanged: (value) =>
                        setState(() => _consultationType = value),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children:
                          [
                                'Servicios Legales',
                                'Soluciones IA',
                                'Ambos',
                                'Otro',
                              ]
                              .map(
                                (type) => InkWell(
                                  onTap: () =>
                                      setState(() => _consultationType = type),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: type,
                                        activeColor: navyColor,
                                      ),
                                      Text(
                                        type,
                                        style: TextStyle(
                                          color: colors.foreground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Preferred office ──────────────────────────────────
                  Text(
                    "Oficina de preferencia",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    key: ValueKey('office_dropdown_$_dropdownResetCounter'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    initialValue: _preferredOffice,
                    items: const [
                      DropdownMenuItem(
                        value: "CDMX",
                        child: Text("Ciudad de México"),
                      ),
                      DropdownMenuItem(
                        value: "GDL",
                        child: Text("Guadalajara"),
                      ),
                      DropdownMenuItem(value: "MIA", child: Text("Miami")),
                      DropdownMenuItem(value: "MAD", child: Text("Madrid")),
                      DropdownMenuItem(
                        value: "Virtual",
                        child: Text("Consulta Virtual"),
                      ),
                    ],
                    onChanged: (val) => setState(() => _preferredOffice = val),
                    hint: const Text("Seleccione una oficina"),
                  ),

                  const SizedBox(height: 32),

                  // ── Message ───────────────────────────────────────────
                  _TextInput(
                    label: "Mensaje *",
                    hint: "Describa su consulta o requerimiento",
                    required: true,
                    maxLines: 6,
                    controller: _messageController,
                  ),

                  const SizedBox(height: 24),

                  // ── Urgency checkbox ──────────────────────────────────
                  InkWell(
                    onTap: () => setState(() => _isUrgent = !_isUrgent),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isUrgent,
                          onChanged: (val) => setState(() => _isUrgent = val!),
                          activeColor: Colors.blue,
                        ),
                        Expanded(
                          child: Text(
                            "Este asunto requiere atención urgente (respuesta en 4 horas hábiles)",
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Contact method ────────────────────────────────────
                  Text(
                    "Método de contacto preferido",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<String>(
                    groupValue: _contactMethod,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _contactMethod = value);
                    },
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => setState(() => _contactMethod = 'email'),
                          child: const Row(
                            children: [
                              Radio<String>(
                                value: 'email',
                                activeColor: Colors.blue,
                              ),
                              Text("Correo electrónico"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        InkWell(
                          onTap: () => setState(() => _contactMethod = 'phone'),
                          child: const Row(
                            children: [
                              Radio<String>(
                                value: 'phone',
                                activeColor: Colors.blue,
                              ),
                              Text("Teléfono"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Submit button ─────────────────────────────────────
                  Semantics(
                    button: true,
                    label: "Enviar mensaje de contacto",
                    child: SizedBox(
                      width: 200,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : () => _submit(),
                        style: FilledButton.styleFrom(
                          backgroundColor: navyColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Enviar Mensaje",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
