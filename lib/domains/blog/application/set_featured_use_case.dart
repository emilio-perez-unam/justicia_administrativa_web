import '../../../core/error/result.dart';
import '../domain/blog_post.dart';
import 'blog_admin_repository.dart';

/// Marks or un-marks a blog post as featured.
class SetFeaturedUseCase {
  final BlogAdminRepository _repository;

  const SetFeaturedUseCase(this._repository);

  Future<Result<BlogPost>> call({
    required String id,
    required bool isFeatured,
  }) => _repository.setFeatured(id: id, isFeatured: isFeatured);
}
