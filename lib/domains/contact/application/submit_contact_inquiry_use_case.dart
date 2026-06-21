import '../../../core/error/result.dart';
import '../domain/contact_inquiry.dart';
import 'contact_inquiry_repository.dart';

/// Submits a [ContactInquiry] through the injected [ContactInquiryRepository].
///
/// This use case is intentionally thin — it acts as a stable entry point for
/// the application layer, shielding callers from repository internals and
/// allowing the repository to be swapped without touching the actor.
class SubmitContactInquiryUseCase {
  final ContactInquiryRepository _repo;

  const SubmitContactInquiryUseCase(this._repo);

  /// Delegates submission to the repository.
  ///
  /// Returns [Ok] with the submitted [ContactInquiry] on success, or
  /// [Err] with the mapped [Failure] on any infrastructure error.
  Future<Result<ContactInquiry>> call(ContactInquiry inquiry) =>
      _repo.submit(inquiry);
}
