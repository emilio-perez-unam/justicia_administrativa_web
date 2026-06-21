import '../application/blog_article_repository.dart';
import '../domain/blog_article.dart';
import 'blog_service.dart';
import 'blog_post_mapper.dart';

class SupabaseBlogArticleRepository implements BlogArticleRepository {
  final BlogPostMapper _mapper;

  const SupabaseBlogArticleRepository({
    BlogPostMapper mapper = const BlogPostMapper(),
  }) : _mapper = mapper;

  @override
  Future<List<BlogArticle>> getPublishedArticles() async {
    final posts = await BlogService.getPublishedPosts();
    return posts.map(_mapper.toArticle).toList(growable: false);
  }
}
