import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/models/portal_message.dart';
import '../../../core/services/portal_service.dart';
import '../application/portal_messaging_repository.dart';

/// Supabase-backed implementation that delegates to [PortalService].
class PortalServiceMessagingRepository implements PortalMessagingRepository {
  const PortalServiceMessagingRepository();

  @override
  Future<Result<List<PortalMessage>>> recentMessages({int limit = 5}) async {
    try {
      final messages = await PortalService.getRecentMessages(limit: limit);
      return Ok(messages);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
