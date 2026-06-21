part of '../blog_admin_view.dart';

extension _BlogPostEditorDialogFields on _BlogPostEditorDialogState {
  Widget _buildPrimaryFields(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: compact
                  ? constraints.maxWidth
                  : constraints.maxWidth * 0.62,
              child: TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredWithLength('un título', min: 8, max: 140),
              ),
            ),
            SizedBox(
              width: compact
                  ? constraints.maxWidth
                  : constraints.maxWidth * 0.33,
              child: TextFormField(
                controller: _categoryController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredWithLength(
                  'una categoría',
                  min: 3,
                  max: 50,
                ),
              ),
            ),
            SizedBox(
              width: compact
                  ? constraints.maxWidth
                  : constraints.maxWidth * 0.75,
              child: TextFormField(
                controller: _slugController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Slug',
                  border: const OutlineInputBorder(),
                  suffixIcon: TextButton(
                    onPressed: _enableAutoSlug,
                    child: const Text('Auto'),
                  ),
                ),
                validator: _slugValidator,
              ),
            ),
            SizedBox(
              width: compact
                  ? constraints.maxWidth
                  : constraints.maxWidth * 0.22,
              child: TextFormField(
                controller: _tagsController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Etiquetas (coma)',
                  border: OutlineInputBorder(),
                ),
                validator: _tagsValidator,
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: TextFormField(
                controller: _imageUrlController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen principal',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredUrl('la URL de imagen'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContentFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _excerptController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Extracto',
            border: OutlineInputBorder(),
          ),
          validator: _requiredWithLength('un extracto', min: 30, max: 320),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contentController,
          minLines: 10,
          maxLines: 14,
          decoration: const InputDecoration(
            labelText: 'Contenido',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          validator: _requiredWithLength('el contenido', min: 120, max: 12000),
        ),
      ],
    );
  }

  Widget _buildAuthorFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Autor',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: compact
                      ? constraints.maxWidth
                      : constraints.maxWidth * 0.48,
                  child: TextFormField(
                    controller: _authorNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del autor',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredWithLength(
                      'el nombre del autor',
                      min: 3,
                      max: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: compact
                      ? constraints.maxWidth
                      : constraints.maxWidth * 0.48,
                  child: TextFormField(
                    controller: _authorRoleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Rol del autor',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredWithLength(
                      'el rol del autor',
                      min: 3,
                      max: 120,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: TextFormField(
                    controller: _authorBioController,
                    maxLines: 2,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Biografía breve',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredWithLength(
                      'la biografía breve',
                      min: 30,
                      max: 280,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth,
                  child: TextFormField(
                    controller: _authorImageController,
                    decoration: const InputDecoration(
                      labelText: 'URL de imagen del autor',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredUrl('la imagen del autor'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPublishingFlags() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isPublished,
            onChanged: _setPublished,
            title: const Text('Publicar inmediatamente'),
            subtitle: const Text(
              'Si se activa, la entrada aparece en la web pública.',
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isFeatured,
            onChanged: _setFeatured,
            title: const Text('Marcar como destacado'),
            subtitle: const Text('Puede mostrarse como artículo principal.'),
          ),
        ],
      ),
    );
  }
}
