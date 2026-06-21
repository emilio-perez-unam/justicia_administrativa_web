import '../../../core/error/result.dart';
import '../domain/blog_post.dart';
import 'blog_admin_repository.dart';

/// Publishes or un-publishes a blog post.
class SetPublishedUseCase {
  final BlogAdminRepository _repository;

  const SetPublishedUseCase(this._repository);

  Future<Result<BlogPost>> call({
    required String id,
    required bool isPublished,
  }) => _repository.setPublished(id: id, isPublished: isPublished);
}
