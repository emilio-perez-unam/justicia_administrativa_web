import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/domains/blog/domain/blog_article.dart';
import 'package:justicia_administrativa_site/domains/blog/domain/blog_catalog.dart';

void main() {
  group('BlogCatalog', () {
    test('keeps featured article out of the visible feed', () {
      final catalog = BlogCatalog([
        _article(id: 'older', publishedAt: DateTime(2026, 1, 1)),
        _article(
          id: 'featured',
          featured: true,
          publishedAt: DateTime(2026, 2, 1),
        ),
        _article(id: 'newer', publishedAt: DateTime(2026, 3, 1)),
      ]);

      expect(
        catalog
            .featuredArticle(
              activeCategory: BlogCatalog.allCategory,
              searchQuery: '',
            )
            ?.id,
        'featured',
      );
      expect(
        catalog
            .feedArticles(
              activeCategory: BlogCatalog.allCategory,
              searchQuery: '',
            )
            .map((article) => article.id),
        ['newer', 'older'],
      );
    });

    test(
      'filters by category and search query without changing Spanish all label',
      () {
        final catalog = BlogCatalog([
          _article(id: 'ai', category: 'IA', title: 'Resoluciones con IA'),
          _article(
            id: 'admin',
            category: 'Derecho',
            title: 'Recurso administrativo',
          ),
        ]);

        expect(catalog.categories.first, BlogCatalog.allCategory);
        expect(BlogCatalog.allCategory, 'Todos los artículos');
        expect(
          catalog
              .filteredArticles(
                activeCategory: 'Derecho',
                searchQuery: 'recurso',
              )
              .map((article) => article.id),
          ['admin'],
        );
      },
    );

    test('ranks repeated topics and preserves load-more bounds', () {
      final catalog = BlogCatalog([
        _article(id: 'one', tags: ['IA', 'Tribunal']),
        _article(id: 'two', tags: ['IA', 'Procedimiento']),
        _article(id: 'three', tags: ['Procedimiento']),
      ]);

      expect(
        catalog
            .popularTopics(
              activeCategory: BlogCatalog.allCategory,
              searchQuery: '',
            )
            .map((topic) => '${topic.topic}:${topic.mentions}'),
        ['IA:2', 'Procedimiento:2', 'Tribunal:1'],
      );
      expect(
        catalog.visibleFeedArticles(
          activeCategory: BlogCatalog.allCategory,
          searchQuery: '',
          visibleArticles: 1,
        ),
        hasLength(1),
      );
      expect(
        catalog.canLoadMore(
          activeCategory: BlogCatalog.allCategory,
          searchQuery: '',
          visibleArticles: 1,
        ),
        isTrue,
      );
    });
  });
}

BlogArticle _article({
  required String id,
  String title = 'Artículo',
  String category = 'Derecho',
  List<String> tags = const ['IA'],
  bool featured = false,
  DateTime? publishedAt,
}) {
  return BlogArticle(
    id: id,
    title: title,
    excerpt: 'Extracto $id',
    content: 'Contenido $id',
    category: category,
    tags: tags,
    publishedAt: publishedAt ?? DateTime(2026, 1, 1),
    readMinutes: 3,
    views: 0,
    comments: 0,
    featured: featured,
    imageUrl: '',
    author: const BlogAuthor(
      id: 'author-1',
      name: 'JusticIA Administrativa',
      role: 'Equipo editorial',
      bio: '',
      imageUrl: '',
    ),
  );
}
