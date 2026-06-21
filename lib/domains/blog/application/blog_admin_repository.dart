import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../domain/blog_post.dart';

/// Write-side port for the blog-admin bounded context.
///
/// Covers all six operations that [BlogAdminView] performs against
/// [BlogService]:
///   1. Load all posts (admin read — includes drafts).
///   2. Create a new post.
///   3. Update an existing post.
///   4. Delete a post by id.
///   5. Toggle published status.
///   6. Toggle featured status.
///
/// Implementations delegate to [BlogService] static methods, wrapped in
/// [Result] so the view receives typed [Failure] values instead of raw
/// exceptions.
abstract class BlogAdminRepository {
  /// Returns all posts (published + drafts), ordered by last update.
  Future<Result<List<BlogPost>>> getAllPosts();

  /// Creates a new post from [input].
  Future<Result<BlogPost>> createPost(BlogPostDraftInput input);

  /// Updates the post identified by [id].
  Future<Result<BlogPost>> updatePost({
    required String id,
    required BlogPostDraftInput input,
    DateTime? previousPublishedAt,
  });

  /// Permanently deletes the post with the given [id].
  Future<Result<Unit>> deletePost(String id);

  /// Sets the published state of the post with [id] to [isPublished].
  Future<Result<BlogPost>> setPublished({
    required String id,
    required bool isPublished,
  });

  /// Sets the featured state of the post with [id] to [isFeatured].
  Future<Result<BlogPost>> setFeatured({
    required String id,
    required bool isFeatured,
  });
}
