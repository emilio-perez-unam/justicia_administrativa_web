import '../domain/blog_post.dart';
import '../domain/blog_article.dart';

const String defaultArticleImageUrl =
    'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?auto=format&fit=crop&w=1280&q=80';
const String defaultAuthorImageUrl =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=320&q=80';

class BlogPostMapper {
  const BlogPostMapper();

  BlogArticle toArticle(BlogPost post) {
    return BlogArticle(
      id: post.id,
      title: post.title,
      excerpt: post.excerpt,
      content: post.content,
      category: post.category,
      tags: post.tags,
      publishedAt: post.publishedAt ?? post.updatedAt,
      readMinutes: post.readMinutes <= 0 ? 1 : post.readMinutes,
      views: post.viewsCount < 0 ? 0 : post.viewsCount,
      comments: post.commentsCount < 0 ? 0 : post.commentsCount,
      featured: post.isFeatured,
      imageUrl: post.imageUrl.trim().isEmpty
          ? defaultArticleImageUrl
          : post.imageUrl,
      author: BlogAuthor(
        id: post.createdBy ?? post.authorName,
        name: post.authorName,
        role: post.authorRole,
        bio: post.authorBio,
        imageUrl: post.authorImageUrl.trim().isEmpty
            ? defaultAuthorImageUrl
            : post.authorImageUrl,
      ),
    );
  }
}
