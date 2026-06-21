part of '../blog_admin_view.dart';

class _BlogPostEditorDialog extends StatefulWidget {
  const _BlogPostEditorDialog({this.existingPost});

  final BlogPost? existingPost;

  @override
  State<_BlogPostEditorDialog> createState() => _BlogPostEditorDialogState();
}

class _BlogPostEditorDialogState extends State<_BlogPostEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _categoryController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _authorRoleController = TextEditingController();
  final _authorBioController = TextEditingController();
  final _authorImageController = TextEditingController();

  bool _isPublished = false;
  bool _isFeatured = false;
  bool _autoSlug = true;

  String? Function(String?) _requiredWithLength(
    String fieldLabel, {
    int min = 2,
    int max = 240,
  }) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Ingrese $fieldLabel.'),
      FormBuilderValidators.minLength(
        min,
        errorText: '$fieldLabel debe tener al menos $min caracteres.',
      ),
      FormBuilderValidators.maxLength(
        max,
        errorText: '$fieldLabel no debe exceder $max caracteres.',
      ),
    ]);
  }

  String? Function(String?) _requiredUrl(String fieldLabel) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Ingrese $fieldLabel.'),
      FormBuilderValidators.url(
        errorText: '$fieldLabel debe ser una URL válida.',
      ),
    ]);
  }

  String? _slugValidator(String? value) {
    final validator = FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Ingrese un slug.'),
      FormBuilderValidators.maxLength(
        120,
        errorText: 'El slug no debe exceder 120 caracteres.',
      ),
      FormBuilderValidators.match(
        RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$'),
        errorText:
            'Use solo minúsculas, números y guiones (ejemplo: mi-articulo).',
      ),
    ]);
    return validator(value);
  }

  String? _tagsValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final tagPattern = RegExp(
      r'^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ,\-_\s]+$',
      unicode: true,
    );
    if (!tagPattern.hasMatch(value.trim())) {
      return 'Use solo letras, números, comas y guiones en etiquetas.';
    }
    final tags = BlogService.parseTags(value);
    if (tags.length > 12) {
      return 'Use máximo 12 etiquetas por entrada.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final post = widget.existingPost;

    if (post == null) {
      _authorNameController.text = AppRouter.authNotifier.displayName;
      _authorRoleController.text = 'Equipo legal de JusticIA Administrativa';
      _authorBioController.text =
          'Especialista en derecho administrativo y tecnología legal.';
      _categoryController.text = 'Derecho Administrativo';
      _imageUrlController.text =
          'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=1280&q=80';
      _authorImageController.text =
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=320&q=80';
    } else {
      _titleController.text = post.title;
      _slugController.text = post.slug;
      _categoryController.text = post.category;
      _excerptController.text = post.excerpt;
      _contentController.text = post.content;
      _tagsController.text = post.tags.join(', ');
      _imageUrlController.text = post.imageUrl;
      _authorNameController.text = post.authorName;
      _authorRoleController.text = post.authorRole;
      _authorBioController.text = post.authorBio;
      _authorImageController.text = post.authorImageUrl;
      _isPublished = post.isPublished;
      _isFeatured = post.isFeatured;
      _autoSlug = false;
    }

    _titleController.addListener(_syncSlugFromTitle);
    _slugController.addListener(_detectManualSlugEdit);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_syncSlugFromTitle)
      ..dispose();
    _slugController
      ..removeListener(_detectManualSlugEdit)
      ..dispose();
    _categoryController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _imageUrlController.dispose();
    _authorNameController.dispose();
    _authorRoleController.dispose();
    _authorBioController.dispose();
    _authorImageController.dispose();
    super.dispose();
  }

  void _syncSlugFromTitle() {
    if (!_autoSlug) return;
    final nextSlug = BlogService.slugify(_titleController.text);
    _slugController.value = _slugController.value.copyWith(
      text: nextSlug,
      selection: TextSelection.collapsed(offset: nextSlug.length),
      composing: TextRange.empty,
    );
  }

  void _detectManualSlugEdit() {
    final generated = BlogService.slugify(_titleController.text);
    if (_slugController.text != generated) {
      _autoSlug = false;
    }
  }

  void _enableAutoSlug() {
    setState(() {
      _autoSlug = true;
      _slugController.text = BlogService.slugify(_titleController.text);
    });
  }

  void _setPublished(bool value) {
    setState(() => _isPublished = value);
  }

  void _setFeatured(bool value) {
    setState(() => _isFeatured = value);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final draft = BlogPostDraftInput(
      title: _titleController.text.trim(),
      slug: _slugController.text.trim(),
      excerpt: _excerptController.text.trim(),
      content: _contentController.text.trim(),
      category: _categoryController.text.trim(),
      tags: BlogService.parseTags(_tagsController.text),
      imageUrl: _imageUrlController.text.trim(),
      authorName: _authorNameController.text.trim(),
      authorRole: _authorRoleController.text.trim(),
      authorBio: _authorBioController.text.trim(),
      authorImageUrl: _authorImageController.text.trim(),
      isFeatured: _isFeatured,
      isPublished: _isPublished,
    );

    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPost != null;
    final colors = context.colors;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920, maxHeight: 820),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing
                              ? 'Editar entrada'
                              : 'Nueva entrada de blog',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: _navy,
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Configure contenido, autoría y estado de publicación.',
                          style: TextStyle(
                            color: colors.mutedForeground,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.x, size: 18),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrimaryFields(context),
                      const SizedBox(height: 16),
                      _buildContentFields(),
                      const SizedBox(height: 16),
                      _buildAuthorFields(),
                      const SizedBox(height: 16),
                      _buildPublishingFlags(),
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: colors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(LucideIcons.save, size: 16),
                    label: Text(
                      isEditing ? 'Guardar cambios' : 'Crear entrada',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
