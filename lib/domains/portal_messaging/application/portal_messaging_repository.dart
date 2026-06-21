import '../../../core/error/result.dart';
import '../../../core/models/portal_message.dart';

/// Port for the portal-messaging domain.  Implementations delegate to whatever
/// data source is appropriate (Supabase, in-memory stub, etc.).
abstract class PortalMessagingRepository {
  /// Returns the most-recent portal messages, limited to [limit] items.
  Future<Result<List<PortalMessage>>> recentMessages({int limit = 5});
}
