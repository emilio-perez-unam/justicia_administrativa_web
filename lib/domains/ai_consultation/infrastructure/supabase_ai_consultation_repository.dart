import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/failure_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/services/chat_service.dart';
import '../application/ai_consultation_repository.dart';

/// Supabase-backed adapter for [AiConsultationRepository].
///
/// Delegates to [ChatService.sendMessage] which invokes the `chat` edge
/// function.  Before the call it checks authentication — if there is no
/// current user it returns [AuthFailure] immediately without hitting the
/// function (which would 500 for unauthenticated requests anyway).
class SupabaseAiConsultationRepository implements AiConsultationRepository {
  /// The Supabase client used for auth checks.
  /// Defaults to [Supabase.instance.client] to allow injection in tests.
  final SupabaseClient _client;

  SupabaseAiConsultationRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    // Guard: the chat edge function requires an authenticated user.
    if (_client.auth.currentUser == null) {
      return const Err(
        AuthFailure(message: 'Inicia sesión para usar el asistente de IA.'),
      );
    }

    try {
      final response = await ChatService.sendMessage(
        content: content,
        conversationId: conversationId,
        webSearch: webSearch,
        attachmentUrl: attachmentUrl,
        attachmentName: attachmentName,
      );
      return Ok(response);
    } catch (e, st) {
      return Err(mapErrorToFailure(e, st));
    }
  }
}
