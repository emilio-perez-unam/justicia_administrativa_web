import '../../../core/error/result.dart';
import '../../../core/error/unit.dart';
import 'blog_admin_repository.dart';

/// Permanently deletes a blog post by its id.
class DeletePostUseCase {
  final BlogAdminRepository _repository;

  const DeletePostUseCase(this._repository);

  Future<Result<Unit>> call(String id) => _repository.deletePost(id);
}
