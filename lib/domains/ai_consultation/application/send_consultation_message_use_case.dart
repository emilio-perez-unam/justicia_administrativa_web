import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/services/chat_service.dart';
import 'ai_consultation_repository.dart';

/// Validates and delegates the sending of an AI consultation message.
///
/// Validates that [content] is non-empty after trimming, returning a
/// [ValidationFailure] immediately without touching the repository.
/// On valid input, delegates to the injected [AiConsultationRepository].
class SendConsultationMessageUseCase {
  final AiConsultationRepository _repo;

  const SendConsultationMessageUseCase(this._repo);

  /// Sends a consultation message.
  ///
  /// Returns [Err] with [ValidationFailure] when [content] is blank.
  /// Returns [Ok] with [ChatResponse] on success.
  /// Returns [Err] with a typed [Failure] on any infrastructure error.
  Future<Result<ChatResponse>> call({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return const Err(ValidationFailure('Escribe un mensaje.'));
    }

    return _repo.sendMessage(
      content: trimmed,
      conversationId: conversationId,
      webSearch: webSearch,
      attachmentUrl: attachmentUrl,
      attachmentName: attachmentName,
    );
  }
}
