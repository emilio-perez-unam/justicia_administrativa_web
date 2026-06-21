import '../../../core/error/result.dart';
import '../domain/blog_post.dart';
import 'blog_admin_repository.dart';

/// Updates an existing blog post.
class UpdatePostUseCase {
  final BlogAdminRepository _repository;

  const UpdatePostUseCase(this._repository);

  Future<Result<BlogPost>> call({
    required String id,
    required BlogPostDraftInput input,
    DateTime? previousPublishedAt,
  }) => _repository.updatePost(
    id: id,
    input: input,
    previousPublishedAt: previousPublishedAt,
  );
}
