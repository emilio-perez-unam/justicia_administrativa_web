part of '../blog.dart';

class _MainBlogContent extends StatelessWidget {
  const _MainBlogContent({
    required this.featuredArticle,
    required this.articles,
    required this.canLoadMore,
    required this.onLoadMore,
    required this.onOpenArticle,
    required this.onToggleSaved,
    required this.onShareArticle,
    required this.isSaved,
  });

  final BlogArticle? featuredArticle;
  final List<BlogArticle> articles;
  final bool canLoadMore;
  final VoidCallback onLoadMore;
  final ValueChanged<BlogArticle> onOpenArticle;
  final ValueChanged<BlogArticle> onToggleSaved;
  final ValueChanged<BlogArticle> onShareArticle;
  final bool Function(BlogArticle article) isSaved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (featuredArticle != null) ...[
          _FeaturedArticleCard(
            article: featuredArticle!,
            isSaved: isSaved(featuredArticle!),
            onRead: () => onOpenArticle(featuredArticle!),
            onSave: () => onToggleSaved(featuredArticle!),
            onShare: () => onShareArticle(featuredArticle!),
          ),
          const SizedBox(height: 32),
        ],
        Text(
          'Artículos recientes',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _navy,
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        if (articles.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(colors.radiusLg),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              'No hay artículos adicionales para mostrar con los filtros actuales.',
              style: TextStyle(color: colors.mutedForeground),
            ),
          )
        else
          ...articles.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ArticleListCard(
                article: article,
                isSaved: isSaved(article),
                onRead: () => onOpenArticle(article),
                onSave: () => onToggleSaved(article),
                onShare: () => onShareArticle(article),
              ),
            ),
          ),
        if (canLoadMore)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: OutlinedButton.icon(
                onPressed: onLoadMore,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Cargar más artículos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _navy,
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedArticleCard extends StatelessWidget {
  const _FeaturedArticleCard({
    required this.article,
    required this.onRead,
    required this.onSave,
    required this.onShare,
    required this.isSaved,
  });

  final BlogArticle article;
  final VoidCallback onRead;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 840;

          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isDesktop
                    ? constraints.maxWidth * 0.56
                    : double.infinity,
                height: isDesktop ? 380 : 230,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _ArticleImage(url: article.imageUrl),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'DESTACADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        article.title,
                        style: TextStyle(
                          color: _navy,
                          fontSize: 27,
                          height: 1.22,
                          fontWeight: FontWeight.w700,
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.excerpt,
                        style: TextStyle(
                          color: colors.mutedForeground,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _AuthorRow(author: article.author),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: onRead,
                            icon: const Icon(LucideIcons.bookOpen, size: 16),
                            label: const Text('Leer artículo'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: onShare,
                            tooltip: 'Compartir',
                            icon: Icon(
                              LucideIcons.share2,
                              color: colors.mutedForeground,
                              size: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: onSave,
                            tooltip: isSaved ? 'Quitar guardado' : 'Guardar',
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? _gold : colors.mutedForeground,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ArticleListCard extends StatelessWidget {
  const _ArticleListCard({
    required this.article,
    required this.onRead,
    required this.onSave,
    required this.onShare,
    required this.isSaved,
  });

  final BlogArticle article;
  final VoidCallback onRead;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 640;

          return Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isCompact ? double.infinity : 220,
                height: isCompact ? 150 : 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.colors.radiusMd),
                  child: _ArticleImage(url: article.imageUrl),
                ),
              ),
              SizedBox(width: isCompact ? 0 : 16, height: isCompact ? 16 : 0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _CategoryPill(label: article.category),
                        Text(
                          _formatDate(article.publishedAt),
                          style: TextStyle(
                            color: colors.mutedForeground,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.clock,
                              size: 12,
                              color: colors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${article.readMinutes} min',
                              style: TextStyle(
                                color: colors.mutedForeground,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.title,
                      style: TextStyle(
                        color: _navy,
                        fontSize: 20,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      article.excerpt,
                      maxLines: 3,
                      minFontSize: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.mutedForeground,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.eye,
                          size: 14,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.views}',
                          style: TextStyle(
                            color: colors.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          LucideIcons.messageSquare,
                          size: 14,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.comments}',
                          style: TextStyle(
                            color: colors.mutedForeground,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onShare,
                          tooltip: 'Compartir',
                          icon: Icon(
                            LucideIcons.share2,
                            size: 16,
                            color: colors.mutedForeground,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          onPressed: onSave,
                          tooltip: isSaved ? 'Quitar guardado' : 'Guardar',
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            size: 16,
                            color: isSaved ? _gold : colors.mutedForeground,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        TextButton(
                          onPressed: onRead,
                          child: const Text('Leer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
