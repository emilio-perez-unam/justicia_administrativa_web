import '../domain/blog_article.dart';
import 'blog_article_repository.dart';

class LoadBlogFeedUseCase {
  final BlogArticleRepository _repository;

  const LoadBlogFeedUseCase(this._repository);

  Future<List<BlogArticle>> call() async {
    final articles = await _repository.getPublishedArticles();
    return articles..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }
}
