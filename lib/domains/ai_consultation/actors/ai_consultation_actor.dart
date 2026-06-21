import 'package:flutter/foundation.dart';

import '../../../core/error/failure.dart';
import '../../../core/services/chat_service.dart';
import '../application/send_consultation_message_use_case.dart';

/// Lifecycle states of an AI consultation message send operation.
enum AiConsultationStatus {
  /// No operation in progress; ready to accept input.
  idle,

  /// A message send is in flight; UI should show a loading indicator.
  sending,

  /// Message sent successfully; [AiConsultationActor.lastResponse] is set.
  success,

  /// Send failed; [AiConsultationActor.failure] describes the error.
  error,
}

/// ChangeNotifier coordinator for the AI consultation chat send flow.
///
/// Exposes [status], [failure], and [lastResponse] as observable state.
/// Widgets listen via [addListener] / [AnimatedBuilder] and rebuild on notify.
///
/// Lifecycle:
/// 1. Construct with a [SendConsultationMessageUseCase].
/// 2. Call [send] — status transitions: idle → sending → success|error.
/// 3. Call [reset] to return to idle (e.g. to allow a retry).
/// 4. [dispose] when the widget is removed.
class AiConsultationActor extends ChangeNotifier {
  final SendConsultationMessageUseCase _useCase;

  /// Current lifecycle status of the send operation.
  AiConsultationStatus get status => _status;
  AiConsultationStatus _status = AiConsultationStatus.idle;

  /// The failure from the most recent unsuccessful send, or `null`.
  Failure? get failure => _failure;
  Failure? _failure;

  /// The response from the most recent successful send, or `null`.
  ChatResponse? get lastResponse => _lastResponse;
  ChatResponse? _lastResponse;

  AiConsultationActor(this._useCase);

  /// Sends [content] through the use case and updates observable state.
  ///
  /// Notifies listeners at least twice: once when sending starts, once when
  /// it ends (success or error).
  Future<void> send({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    _status = AiConsultationStatus.sending;
    _failure = null;
    _lastResponse = null;
    notifyListeners();

    final result = await _useCase(
      content: content,
      conversationId: conversationId,
      webSearch: webSearch,
      attachmentUrl: attachmentUrl,
      attachmentName: attachmentName,
    );

    result.fold(
      (response) {
        _status = AiConsultationStatus.success;
        _lastResponse = response;
        _failure = null;
      },
      (failure) {
        _status = AiConsultationStatus.error;
        _failure = failure;
        _lastResponse = null;
      },
    );

    notifyListeners();
  }

  /// Resets status to [AiConsultationStatus.idle] and clears failure and
  /// lastResponse, enabling the user to retry.
  void reset() {
    _status = AiConsultationStatus.idle;
    _failure = null;
    _lastResponse = null;
    notifyListeners();
  }
}
