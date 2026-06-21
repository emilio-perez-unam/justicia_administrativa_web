part of '../blog.dart';

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onReset, required this.hasActiveFilters});

  final VoidCallback onReset;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.searchX, color: colors.mutedForeground, size: 30),
          const SizedBox(height: 12),
          Text(
            hasActiveFilters
                ? 'No encontramos artículos con esos filtros.'
                : 'Aún no hay artículos publicados.',
            style: TextStyle(
              color: _navy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? 'Pruebe otra categoría o utilice palabras clave más amplias.'
                : 'Estamos preparando contenido jurídico para este espacio.',
            style: TextStyle(color: colors.mutedForeground, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(LucideIcons.rotateCcw, size: 14),
              label: const Text('Restablecer filtros'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArticleDialog extends StatelessWidget {
  const _ArticleDialog({
    required this.article,
    required this.onToggleSaved,
    required this.onShare,
    required this.isSaved,
  });

  final BlogArticle article;
  final VoidCallback onToggleSaved;
  final VoidCallback onShare;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.colors.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860, maxHeight: 780),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: _ArticleImage(url: article.imageUrl),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _CategoryPill(label: article.category),
                              Text(
                                _formatDate(article.publishedAt),
                                style: TextStyle(
                                  color: colors.mutedForeground,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${article.readMinutes} min de lectura',
                                style: TextStyle(
                                  color: colors.mutedForeground,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            article.title,
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.22,
                              fontWeight: FontWeight.w700,
                              color: _navy,
                              fontFamily:
                                  GoogleFonts.playfairDisplay().fontFamily,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _AuthorRow(author: article.author),
                          const SizedBox(height: 16),
                          Text(
                            article.content,
                            style: TextStyle(
                              color: colors.foreground,
                              fontSize: 15,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: article.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.secondary.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(color: colors.border),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        color: colors.mutedForeground,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: onShare,
                    icon: const Icon(LucideIcons.share2, size: 16),
                    label: const Text('Compartir'),
                  ),
                  TextButton.icon(
                    onPressed: onToggleSaved,
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: 16,
                    ),
                    label: Text(isSaved ? 'Guardado' : 'Guardar'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(backgroundColor: _navy),
                    child: const Text('Cerrar'),
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

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: _teal,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, _, __) => Container(
        color: const Color(0xFFE5E7EB),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF9CA3AF),
          size: 40,
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.author});

  final BlogAuthor author;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: author.imageUrl,
            width: 38,
            height: 38,
            fit: BoxFit.cover,
            errorWidget: (context, _, __) => Container(
              width: 38,
              height: 38,
              color: const Color(0xFFE5E7EB),
              child: const Icon(
                Icons.person,
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                author.role,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.mutedForeground, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
