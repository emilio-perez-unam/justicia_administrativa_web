import '../../../core/error/result.dart';
import '../domain/blog_post.dart';
import 'blog_admin_repository.dart';

/// Creates a new blog post from a draft input.
class CreatePostUseCase {
  final BlogAdminRepository _repository;

  const CreatePostUseCase(this._repository);

  Future<Result<BlogPost>> call(BlogPostDraftInput input) =>
      _repository.createPost(input);
}
