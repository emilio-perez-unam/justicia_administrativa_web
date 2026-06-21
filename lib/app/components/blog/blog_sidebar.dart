part of '../blog.dart';

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.featuredAuthor,
    required this.popularTopics,
    required this.mostCommented,
    required this.newsletterController,
    required this.onTopicTap,
    required this.onOpenArticle,
    required this.onSubscribe,
  });

  final AuthorStats? featuredAuthor;
  final List<TopicStat> popularTopics;
  final List<BlogArticle> mostCommented;
  final TextEditingController newsletterController;
  final ValueChanged<String> onTopicTap;
  final ValueChanged<BlogArticle> onOpenArticle;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (featuredAuthor != null) ...[
          _FeaturedAuthorCard(stats: featuredAuthor!),
          const SizedBox(height: 20),
        ],
        _PopularTopicsCard(topics: popularTopics, onTopicTap: onTopicTap),
        const SizedBox(height: 20),
        _MostCommentedCard(
          articles: mostCommented,
          onOpenArticle: onOpenArticle,
        ),
        const SizedBox(height: 20),
        _NewsletterCard(
          controller: newsletterController,
          onSubscribe: onSubscribe,
        ),
      ],
    );
  }
}

class _FeaturedAuthorCard extends StatelessWidget {
  const _FeaturedAuthorCard({required this.stats});

  final AuthorStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _SidebarCard(
      title: 'Autor destacado',
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: stats.author.imageUrl,
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              errorWidget: (context, _, __) => Container(
                width: 84,
                height: 84,
                color: const Color(0xFFE5E7EB),
                child: const Icon(Icons.person, color: Color(0xFF9CA3AF)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stats.author.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stats.author.role,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.mutedForeground, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            stats.author.bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              '${stats.articleCount} artículos publicados',
              style: const TextStyle(
                fontSize: 11,
                color: _navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularTopicsCard extends StatelessWidget {
  const _PopularTopicsCard({required this.topics, required this.onTopicTap});

  final List<TopicStat> topics;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _SidebarCard(
      title: 'Temas populares',
      child: topics.isEmpty
          ? Text(
              'Sin temas publicados todavía.',
              style: TextStyle(color: colors.mutedForeground, fontSize: 13),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics
                  .map(
                    (topic) => ActionChip(
                      label: Text('${topic.topic} (${topic.mentions})'),
                      onPressed: () => onTopicTap(topic.topic),
                      backgroundColor: colors.secondary.withValues(alpha: 0.35),
                      side: BorderSide(color: colors.border),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: colors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _MostCommentedCard extends StatelessWidget {
  const _MostCommentedCard({
    required this.articles,
    required this.onOpenArticle,
  });

  final List<BlogArticle> articles;
  final ValueChanged<BlogArticle> onOpenArticle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _SidebarCard(
      title: 'Más comentados',
      child: articles.isEmpty
          ? Text(
              'Todavía no hay conversaciones en el blog.',
              style: TextStyle(color: colors.mutedForeground, fontSize: 13),
            )
          : Column(
              children: articles
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => onOpenArticle(entry.value),
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: _navy,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.value.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _navy,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${entry.value.comments} comentarios',
                                    style: TextStyle(
                                      color: colors.mutedForeground,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _NewsletterCard extends StatelessWidget {
  const _NewsletterCard({required this.controller, required this.onSubscribe});

  final TextEditingController controller;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(context.colors.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suscríbase al boletín legal',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.3,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Reciba análisis semanales sobre derecho administrativo e innovación legal.',
            style: TextStyle(
              color: Colors.blue.shade100,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Correo electrónico',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSubscribe,
              icon: const Icon(LucideIcons.send, size: 14),
              label: const Text('Suscribirme'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: _navy,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarCard extends StatelessWidget {
  const _SidebarCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              fontWeight: FontWeight.w700,
              color: _navy,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: colors.border),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
