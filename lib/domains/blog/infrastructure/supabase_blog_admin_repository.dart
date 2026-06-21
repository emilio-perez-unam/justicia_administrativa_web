import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import '../application/blog_admin_repository.dart';
import '../domain/blog_post.dart';
import 'blog_service.dart';

/// Supabase-backed implementation that delegates every operation to the
/// existing [BlogService] static methods, wrapped in [Result].
class SupabaseBlogAdminRepository implements BlogAdminRepository {
  const SupabaseBlogAdminRepository();

  @override
  Future<Result<List<BlogPost>>> getAllPosts() async {
    try {
      final posts = await BlogService.getAllPosts();
      return Ok(posts);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<BlogPost>> createPost(BlogPostDraftInput input) async {
    try {
      final post = await BlogService.createPost(input);
      return Ok(post);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<BlogPost>> updatePost({
    required String id,
    required BlogPostDraftInput input,
    DateTime? previousPublishedAt,
  }) async {
    try {
      final post = await BlogService.updatePost(
        id: id,
        input: input,
        previousPublishedAt: previousPublishedAt,
      );
      return Ok(post);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<Unit>> deletePost(String id) async {
    try {
      await BlogService.deletePost(id);
      return Ok(unit);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<BlogPost>> setPublished({
    required String id,
    required bool isPublished,
  }) async {
    try {
      final post = await BlogService.setPublished(
        id: id,
        isPublished: isPublished,
      );
      return Ok(post);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }

  @override
  Future<Result<BlogPost>> setFeatured({
    required String id,
    required bool isFeatured,
  }) async {
    try {
      final post = await BlogService.setFeatured(
        id: id,
        isFeatured: isFeatured,
      );
      return Ok(post);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
