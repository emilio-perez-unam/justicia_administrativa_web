import '../../../core/error/result.dart';
import '../../../core/services/chat_service.dart';

/// Port that must be implemented by any infrastructure adapter that sends
/// AI consultation messages.  Follows the DDD hexagonal pattern — the port
/// lives in the application layer; adapters live in infrastructure.
abstract class AiConsultationRepository {
  /// Sends an AI consultation message and returns the server response.
  ///
  /// Returns [Ok] with a [ChatResponse] on success, or [Err] carrying a
  /// typed [Failure] (e.g. [AuthFailure] if the user is not authenticated,
  /// [NetworkFailure] on connectivity problems, [ServerFailure] on 5xx).
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  });
}
