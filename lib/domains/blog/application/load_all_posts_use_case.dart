import '../../../core/error/result.dart';
import '../domain/blog_post.dart';
import 'blog_admin_repository.dart';

/// Loads all blog posts for the admin panel (includes drafts).
class LoadAllPostsUseCase {
  final BlogAdminRepository _repository;

  const LoadAllPostsUseCase(this._repository);

  Future<Result<List<BlogPost>>> call() => _repository.getAllPosts();
}
