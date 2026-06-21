import 'blog_article.dart';

class BlogCatalog {
  static const String allCategory = 'Todos los artículos';

  final List<BlogArticle> articles;

  const BlogCatalog(this.articles);

  List<String> get categories {
    final categorySet = <String>{
      for (final article in articles) article.category,
    }.toList()..sort();

    return <String>[allCategory, ...categorySet];
  }

  List<BlogArticle> filteredArticles({
    required String activeCategory,
    required String searchQuery,
  }) {
    final query = searchQuery.toLowerCase();
    final filtered = articles.where((article) {
      final matchesCategory =
          activeCategory == allCategory || article.category == activeCategory;

      if (!matchesCategory) return false;
      if (query.isEmpty) return true;

      return article.searchableText().contains(query);
    }).toList()..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return filtered;
  }

  BlogArticle? featuredArticle({
    required String activeCategory,
    required String searchQuery,
  }) {
    final filtered = filteredArticles(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    );
    if (filtered.isEmpty) return null;

    for (final article in filtered) {
      if (article.featured) return article;
    }

    return filtered.first;
  }

  List<BlogArticle> feedArticles({
    required String activeCategory,
    required String searchQuery,
  }) {
    final featuredId = featuredArticle(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    )?.id;

    return filteredArticles(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    ).where((article) => article.id != featuredId).toList();
  }

  List<BlogArticle> visibleFeedArticles({
    required String activeCategory,
    required String searchQuery,
    required int visibleArticles,
  }) {
    final feed = feedArticles(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    );
    final upperBound = visibleArticles.clamp(0, feed.length);
    return feed.take(upperBound).toList();
  }

  bool canLoadMore({
    required String activeCategory,
    required String searchQuery,
    required int visibleArticles,
  }) {
    return feedArticles(
          activeCategory: activeCategory,
          searchQuery: searchQuery,
        ).length >
        visibleFeedArticles(
          activeCategory: activeCategory,
          searchQuery: searchQuery,
          visibleArticles: visibleArticles,
        ).length;
  }

  AuthorStats? featuredAuthor() {
    if (articles.isEmpty) return null;

    final counts = <String, int>{};
    final authorsById = <String, BlogAuthor>{};

    for (final article in articles) {
      counts.update(article.author.id, (value) => value + 1, ifAbsent: () => 1);
      authorsById[article.author.id] = article.author;
    }

    final topAuthorId = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    final author = authorsById[topAuthorId]!;
    return AuthorStats(author: author, articleCount: counts[topAuthorId] ?? 0);
  }

  List<TopicStat> popularTopics({
    required String activeCategory,
    required String searchQuery,
  }) {
    final filtered = filteredArticles(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    );
    final scope = filtered.isEmpty ? articles : filtered;
    final topicCounts = <String, int>{};

    for (final article in scope) {
      for (final topic in article.tags) {
        topicCounts.update(topic, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final ranked =
        topicCounts.entries
            .map((entry) => TopicStat(topic: entry.key, mentions: entry.value))
            .toList()
          ..sort((a, b) {
            final byMentions = b.mentions.compareTo(a.mentions);
            if (byMentions != 0) return byMentions;
            return a.topic.compareTo(b.topic);
          });

    return ranked.take(8).toList();
  }

  List<BlogArticle> mostCommented({
    required String activeCategory,
    required String searchQuery,
  }) {
    final filtered = filteredArticles(
      activeCategory: activeCategory,
      searchQuery: searchQuery,
    );
    final source = filtered.isEmpty ? articles : filtered;

    final ranked = [...source]
      ..sort((a, b) {
        final byComments = b.comments.compareTo(a.comments);
        if (byComments != 0) return byComments;
        return b.publishedAt.compareTo(a.publishedAt);
      });

    return ranked.take(3).toList();
  }
}
