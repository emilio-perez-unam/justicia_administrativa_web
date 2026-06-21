import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domains/blog/actors/blog_feed_actor.dart';
import '../../domains/blog/application/load_blog_feed_use_case.dart';
import '../../domains/blog/domain/blog_article.dart';
import '../../domains/blog/domain/blog_catalog.dart';
import '../../domains/blog/infrastructure/supabase_blog_article_repository.dart';
import '../../core/services/newsletter_service.dart';
import '../../core/theme/app_theme_extension.dart';
import 'section_container.dart';

part 'blog/blog_article_dialog.dart';
part 'blog/blog_feed.dart';
part 'blog/blog_header.dart';
part 'blog/blog_loading_state.dart';
part 'blog/blog_sidebar.dart';

const Color _navy = Color(0xFF1E3A8A);
const Color _gold = Color(0xFFD4AF37);
const Color _teal = Color(0xFF0D9488);
const String _allCategory = BlogCatalog.allCategory;

String _formatDate(DateTime value) {
  const months = <String>[
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return '${value.day} ${months[value.month - 1]} ${value.year}';
}

class BlogSection extends StatefulWidget {
  const BlogSection({super.key});

  @override
  State<BlogSection> createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newsletterController = TextEditingController();
  late final BlogFeedActor _blogFeedActor;
  late StreamSubscription<BlogFeedState> _blogFeedSubscription;
  BlogFeedState _blogState = BlogFeedState.initial();

  @override
  void initState() {
    super.initState();
    _blogFeedActor = BlogFeedActor(
      loadBlogFeed: LoadBlogFeedUseCase(SupabaseBlogArticleRepository()),
    );
    _blogFeedSubscription = _blogFeedActor.stream.listen((state) {
      if (!mounted) return;
      setState(() => _blogState = state);
    });
    _searchController.addListener(_handleSearchChanged);
    _loadArticles();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    _newsletterController.dispose();
    unawaited(_blogFeedSubscription.cancel());
    unawaited(_blogFeedActor.dispose());
    super.dispose();
  }

  void _handleSearchChanged() {
    final nextQuery = _searchController.text.trim();
    if (nextQuery == _blogState.searchQuery) return;
    unawaited(_blogFeedActor.dispatch(BlogSearchChanged(nextQuery)));
  }

  void _handleCategorySelected(String category) {
    unawaited(_blogFeedActor.dispatch(BlogCategorySelected(category)));
  }

  void _clearFilters() {
    _searchController.clear();
    unawaited(_blogFeedActor.dispatch(const BlogFiltersCleared()));
  }

  void _loadMore() {
    unawaited(_blogFeedActor.dispatch(const BlogMoreArticlesRequested()));
  }

  void _toggleSaved(BlogArticle article) {
    final willBeSaved = !_blogState.isSaved(article.id);
    unawaited(_blogFeedActor.dispatch(BlogSavedToggled(article.id)));

    _showSnack(
      willBeSaved
          ? 'Artículo guardado en favoritos.'
          : 'Artículo eliminado de favoritos.',
    );
  }

  Future<void> _shareArticle(BlogArticle article) async {
    final shareLink = 'https://justiciadministrativa.com/blog#${article.id}';
    await Clipboard.setData(
      ClipboardData(text: '$shareLink\n\n${article.title}'),
    );
    if (!mounted) return;
    _showSnack('Enlace copiado al portapapeles.');
  }

  void _openArticle(BlogArticle article) {
    showDialog<void>(
      context: context,
      builder: (context) => _ArticleDialog(
        article: article,
        isSaved: _blogState.isSaved(article.id),
        onToggleSaved: () {
          Navigator.of(context).pop();
          _toggleSaved(article);
        },
        onShare: () {
          Navigator.of(context).pop();
          _shareArticle(article);
        },
      ),
    );
  }

  Future<void> _subscribeNewsletter() async {
    final email = _newsletterController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      _showSnack('Ingrese un correo electrónico válido.', isError: true);
      return;
    }

    try {
      await NewsletterService.subscribe(email);
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        'No se pudo registrar la suscripción. Intente de nuevo más tarde.',
        isError: true,
      );
      return;
    }

    if (!mounted) return;
    _newsletterController.clear();
    _showSnack('Suscripción registrada. Gracias por seguir nuestro blog.');
  }

  void _searchByTopic(String topic) {
    _searchController.text = topic;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: topic.length),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    final colors = context.colors;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? colors.destructive : _navy,
          content: Text(message),
        ),
      );
  }

  Future<void> _loadArticles() async {
    await _blogFeedActor.dispatch(const LoadBlogArticles());
  }

  @override
  Widget build(BuildContext context) {
    if (_blogState.isLoading) {
      return SectionContainer(
        padding: const EdgeInsets.fromLTRB(24, 96, 24, 112),
        child: _BlogLoadingState(),
      );
    }

    if (_blogState.loadErrorMessage != null) {
      final colors = context.colors;
      return SectionContainer(
        padding: const EdgeInsets.fromLTRB(24, 96, 24, 112),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(colors.radiusLg),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.alertCircle,
                color: Color(0xFFB91C1C),
                size: 24,
              ),
              const SizedBox(height: 10),
              const Text(
                'No fue posible cargar el blog',
                style: TextStyle(
                  color: _navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _blogState.loadErrorMessage!,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _loadArticles,
                icon: const Icon(LucideIcons.refreshCcw, size: 16),
                label: const Text('Reintentar'),
                style: FilledButton.styleFrom(backgroundColor: _navy),
              ),
            ],
          ),
        ),
      );
    }

    final filteredArticles = _blogState.filteredArticles;
    final featuredArticle = _blogState.featuredArticle;

    return SectionContainer(
      padding: const EdgeInsets.fromLTRB(24, 96, 24, 112),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BlogHeader(
            searchController: _searchController,
            query: _blogState.searchQuery,
            onClearSearch: _blogState.searchQuery.isEmpty
                ? null
                : () => _searchController.clear(),
            resultCount: filteredArticles.length,
            activeCategory: _blogState.activeCategory,
            totalCount: _blogState.articles.length,
          ),
          const SizedBox(height: 24),
          _BlogCategoryTabs(
            categories: _blogState.categories,
            activeCategory: _blogState.activeCategory,
            onSelected: _handleCategorySelected,
          ),
          const SizedBox(height: 36),
          if (filteredArticles.isEmpty)
            _EmptyResults(
              onReset: _clearFilters,
              hasActiveFilters:
                  _blogState.searchQuery.isNotEmpty ||
                  _blogState.activeCategory != _allCategory,
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final useSingleColumn = constraints.maxWidth < 1040;

                if (useSingleColumn) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MainBlogContent(
                        featuredArticle: featuredArticle,
                        articles: _blogState.visibleFeedArticles,
                        canLoadMore: _blogState.canLoadMore,
                        onLoadMore: _loadMore,
                        onOpenArticle: _openArticle,
                        onToggleSaved: _toggleSaved,
                        onShareArticle: _shareArticle,
                        isSaved: (article) => _blogState.isSaved(article.id),
                      ),
                      const SizedBox(height: 48),
                      _Sidebar(
                        featuredAuthor: _blogState.featuredAuthor,
                        popularTopics: _blogState.popularTopics,
                        mostCommented: _blogState.mostCommented,
                        newsletterController: _newsletterController,
                        onTopicTap: _searchByTopic,
                        onOpenArticle: _openArticle,
                        onSubscribe: _subscribeNewsletter,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: _MainBlogContent(
                        featuredArticle: featuredArticle,
                        articles: _blogState.visibleFeedArticles,
                        canLoadMore: _blogState.canLoadMore,
                        onLoadMore: _loadMore,
                        onOpenArticle: _openArticle,
                        onToggleSaved: _toggleSaved,
                        onShareArticle: _shareArticle,
                        isSaved: (article) => _blogState.isSaved(article.id),
                      ),
                    ),
                    const SizedBox(width: 36),
                    Expanded(
                      flex: 4,
                      child: _Sidebar(
                        featuredAuthor: _blogState.featuredAuthor,
                        popularTopics: _blogState.popularTopics,
                        mostCommented: _blogState.mostCommented,
                        newsletterController: _newsletterController,
                        onTopicTap: _searchByTopic,
                        onOpenArticle: _openArticle,
                        onSubscribe: _subscribeNewsletter,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
