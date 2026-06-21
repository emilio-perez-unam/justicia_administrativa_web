import '../../../core/error/result.dart';
import '../domain/contact_inquiry.dart';

/// Port that must be implemented by any infrastructure adapter that persists
/// contact inquiries.  Follows the DDD hexagonal pattern used by the blog
/// slice — the port lives in the application layer; adapters in infrastructure.
abstract class ContactInquiryRepository {
  /// Persists [inquiry] and returns the same entity on success, or an [Err]
  /// carrying a [Failure] on any infrastructure or network error.
  Future<Result<ContactInquiry>> submit(ContactInquiry inquiry);
}
