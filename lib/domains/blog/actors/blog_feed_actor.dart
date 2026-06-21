import 'dart:async';

import '../application/load_blog_feed_use_case.dart';
import '../domain/blog_article.dart';
import '../domain/blog_catalog.dart';

abstract class BlogFeedMessage {
  const BlogFeedMessage();
}

class LoadBlogArticles extends BlogFeedMessage {
  const LoadBlogArticles();
}

class BlogSearchChanged extends BlogFeedMessage {
  final String query;

  const BlogSearchChanged(this.query);
}

class BlogCategorySelected extends BlogFeedMessage {
  final String category;

  const BlogCategorySelected(this.category);
}

class BlogFiltersCleared extends BlogFeedMessage {
  const BlogFiltersCleared();
}

class BlogMoreArticlesRequested extends BlogFeedMessage {
  final int increment;

  const BlogMoreArticlesRequested({this.increment = 3});
}

class BlogSavedToggled extends BlogFeedMessage {
  final String articleId;

  const BlogSavedToggled(this.articleId);
}

class BlogFeedState {
  static const int initialVisibleArticles = 4;

  final List<BlogArticle> articles;
  final bool isLoading;
  final String? loadErrorMessage;
  final String activeCategory;
  final String searchQuery;
  final int visibleArticles;
  final Set<String> savedArticleIds;

  const BlogFeedState({
    required this.articles,
    required this.isLoading,
    required this.loadErrorMessage,
    required this.activeCategory,
    required this.searchQuery,
    required this.visibleArticles,
    required this.savedArticleIds,
  });

  factory BlogFeedState.initial() {
    return const BlogFeedState(
      articles: <BlogArticle>[],
      isLoading: true,
      loadErrorMessage: null,
      activeCategory: BlogCatalog.allCategory,
      searchQuery: '',
      visibleArticles: initialVisibleArticles,
      savedArticleIds: <String>{},
    );
  }

  BlogCatalog get catalog => BlogCatalog(articles);

  List<String> get categories => catalog.categories;

  List<BlogArticle> get filteredArticles => catalog.filteredArticles(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
  );

  BlogArticle? get featuredArticle => catalog.featuredArticle(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
  );

  List<BlogArticle> get visibleFeedArticles => catalog.visibleFeedArticles(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
    visibleArticles: visibleArticles,
  );

  bool get canLoadMore => catalog.canLoadMore(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
    visibleArticles: visibleArticles,
  );

  AuthorStats? get featuredAuthor => catalog.featuredAuthor();

  List<TopicStat> get popularTopics => catalog.popularTopics(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
  );

  List<BlogArticle> get mostCommented => catalog.mostCommented(
    activeCategory: activeCategory,
    searchQuery: searchQuery,
  );

  bool isSaved(String articleId) => savedArticleIds.contains(articleId);

  BlogFeedState copyWith({
    List<BlogArticle>? articles,
    bool? isLoading,
    String? loadErrorMessage,
    bool clearLoadErrorMessage = false,
    String? activeCategory,
    String? searchQuery,
    int? visibleArticles,
    Set<String>? savedArticleIds,
  }) {
    return BlogFeedState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : loadErrorMessage ?? this.loadErrorMessage,
      activeCategory: activeCategory ?? this.activeCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      visibleArticles: visibleArticles ?? this.visibleArticles,
      savedArticleIds: savedArticleIds ?? this.savedArticleIds,
    );
  }
}

class BlogFeedActor {
  final LoadBlogFeedUseCase _loadBlogFeed;
  final StreamController<BlogFeedState> _controller =
      StreamController<BlogFeedState>.broadcast();

  BlogFeedState _state = BlogFeedState.initial();
  bool _isDisposed = false;

  BlogFeedActor({required LoadBlogFeedUseCase loadBlogFeed})
    : _loadBlogFeed = loadBlogFeed;

  BlogFeedState get state => _state;

  Stream<BlogFeedState> get stream => _controller.stream;

  Future<void> dispatch(BlogFeedMessage message) async {
    if (_isDisposed) return;

    if (message is LoadBlogArticles) {
      return _loadArticles();
    }
    if (message is BlogSearchChanged) {
      _emit(
        _state.copyWith(
          searchQuery: message.query.trim(),
          visibleArticles: BlogFeedState.initialVisibleArticles,
        ),
      );
      return;
    }
    if (message is BlogCategorySelected) {
      if (message.category == _state.activeCategory) return;
      _emit(
        _state.copyWith(
          activeCategory: message.category,
          visibleArticles: BlogFeedState.initialVisibleArticles,
        ),
      );
      return;
    }
    if (message is BlogFiltersCleared) {
      _emit(
        _state.copyWith(
          searchQuery: '',
          activeCategory: BlogCatalog.allCategory,
          visibleArticles: BlogFeedState.initialVisibleArticles,
        ),
      );
      return;
    }
    if (message is BlogMoreArticlesRequested) {
      _emit(
        _state.copyWith(
          visibleArticles: _state.visibleArticles + message.increment,
        ),
      );
      return;
    }
    if (message is BlogSavedToggled) {
      final nextSaved = <String>{..._state.savedArticleIds};
      if (nextSaved.contains(message.articleId)) {
        nextSaved.remove(message.articleId);
      } else {
        nextSaved.add(message.articleId);
      }
      _emit(_state.copyWith(savedArticleIds: nextSaved));
    }
  }

  Future<void> _loadArticles() async {
    _emit(_state.copyWith(isLoading: true, clearLoadErrorMessage: true));

    try {
      final articles = await _loadBlogFeed();
      final validArticleIds = articles.map((article) => article.id).toSet();
      final nextSaved = _state.savedArticleIds
          .where(validArticleIds.contains)
          .toSet();

      _emit(
        _state.copyWith(
          articles: articles,
          isLoading: false,
          clearLoadErrorMessage: true,
          visibleArticles: BlogFeedState.initialVisibleArticles,
          savedArticleIds: nextSaved,
        ),
      );
    } catch (error) {
      _emit(
        _state.copyWith(
          isLoading: false,
          loadErrorMessage:
              'No se pudieron cargar los artículos del blog. $error',
        ),
      );
    }
  }

  void _emit(BlogFeedState nextState) {
    if (_isDisposed) return;
    _state = nextState;
    _controller.add(nextState);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await _controller.close();
  }
}
