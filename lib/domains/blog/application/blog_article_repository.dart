import '../domain/blog_article.dart';

abstract class BlogArticleRepository {
  Future<List<BlogArticle>> getPublishedArticles();
}
