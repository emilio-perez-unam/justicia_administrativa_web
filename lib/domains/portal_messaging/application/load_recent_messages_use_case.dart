import '../../../core/error/result.dart';
import '../../../core/models/portal_message.dart';
import 'portal_messaging_repository.dart';

/// Retrieves the most recent portal messages for the current user.
class LoadRecentMessagesUseCase {
  final PortalMessagingRepository _repository;

  const LoadRecentMessagesUseCase(this._repository);

  Future<Result<List<PortalMessage>>> call({int limit = 5}) =>
      _repository.recentMessages(limit: limit);
}
