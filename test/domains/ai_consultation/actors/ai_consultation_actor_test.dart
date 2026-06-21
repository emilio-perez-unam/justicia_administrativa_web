import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/services/chat_service.dart';
import 'package:justicia_administrativa_site/core/models/message.dart';
import 'package:justicia_administrativa_site/domains/ai_consultation/application/ai_consultation_repository.dart';
import 'package:justicia_administrativa_site/domains/ai_consultation/application/send_consultation_message_use_case.dart';
import 'package:justicia_administrativa_site/domains/ai_consultation/actors/ai_consultation_actor.dart';

// ---------------------------------------------------------------------------
// Controllable fake repository.
// ---------------------------------------------------------------------------
class _ControllableRepo implements AiConsultationRepository {
  late Future<Result<ChatResponse>> Function({
    required String content,
    String? conversationId,
    bool webSearch,
    String? attachmentUrl,
    String? attachmentName,
  })
  _handler;

  void willReturn(Result<ChatResponse> result) {
    _handler =
        ({
          required content,
          conversationId,
          webSearch = false,
          attachmentUrl,
          attachmentName,
        }) async => result;
  }

  void willDelay(Result<ChatResponse> result, Duration delay) {
    _handler =
        ({
          required content,
          conversationId,
          webSearch = false,
          attachmentUrl,
          attachmentName,
        }) async {
          await Future.delayed(delay);
          return result;
        };
  }

  @override
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) => _handler(
    content: content,
    conversationId: conversationId,
    webSearch: webSearch,
    attachmentUrl: attachmentUrl,
    attachmentName: attachmentName,
  );
}

// ---------------------------------------------------------------------------
// Shared fixture.
// ---------------------------------------------------------------------------
ChatResponse _sampleResponse() => ChatResponse(
  conversationId: 'conv-test',
  message: Message(
    id: 'm-test',
    role: 'assistant',
    content: 'Respuesta del asistente.',
    createdAt: DateTime(2025, 6, 1),
  ),
);

void main() {
  late _ControllableRepo repo;
  late SendConsultationMessageUseCase useCase;
  late AiConsultationActor actor;

  setUp(() {
    repo = _ControllableRepo();
    useCase = SendConsultationMessageUseCase(repo);
    actor = AiConsultationActor(useCase);
  });

  tearDown(() => actor.dispose());

  group('AiConsultationActor — initial state', () {
    test('starts in idle status', () {
      expect(actor.status, AiConsultationStatus.idle);
    });

    test('failure is null initially', () {
      expect(actor.failure, isNull);
    });

    test('lastResponse is null initially', () {
      expect(actor.lastResponse, isNull);
    });
  });

  group('AiConsultationActor — successful send', () {
    test('transitions idle → sending → success', () async {
      final response = _sampleResponse();
      repo.willReturn(Ok(response));

      final statuses = <AiConsultationStatus>[];
      actor.addListener(() => statuses.add(actor.status));

      await actor.send(content: 'Mi consulta');

      expect(
        statuses,
        containsAllInOrder([
          AiConsultationStatus.sending,
          AiConsultationStatus.success,
        ]),
      );
      expect(actor.status, AiConsultationStatus.success);
    });

    test('failure is null after success', () async {
      repo.willReturn(Ok(_sampleResponse()));
      await actor.send(content: 'Consulta');
      expect(actor.failure, isNull);
    });

    test('lastResponse is set after success', () async {
      final response = _sampleResponse();
      repo.willReturn(Ok(response));
      await actor.send(content: 'Consulta');
      expect(actor.lastResponse?.conversationId, 'conv-test');
    });
  });

  group('AiConsultationActor — failed send', () {
    test('transitions idle → sending → error on ServerFailure', () async {
      repo.willReturn(const Err(ServerFailure()));

      final statuses = <AiConsultationStatus>[];
      actor.addListener(() => statuses.add(actor.status));

      await actor.send(content: 'Consulta');

      expect(
        statuses,
        containsAllInOrder([
          AiConsultationStatus.sending,
          AiConsultationStatus.error,
        ]),
      );
      expect(actor.status, AiConsultationStatus.error);
    });

    test('failure is set after error', () async {
      repo.willReturn(const Err(ServerFailure()));
      await actor.send(content: 'Consulta');
      expect(actor.failure, isA<ServerFailure>());
    });

    test('transitions to error on AuthFailure', () async {
      repo.willReturn(
        const Err(
          AuthFailure(message: 'Inicia sesión para usar el asistente de IA.'),
        ),
      );

      await actor.send(content: 'Consulta');

      expect(actor.status, AiConsultationStatus.error);
      expect(actor.failure, isA<AuthFailure>());
      expect(
        actor.failure?.message,
        'Inicia sesión para usar el asistente de IA.',
      );
    });

    test('transitions to error on NetworkFailure', () async {
      repo.willReturn(const Err(NetworkFailure()));
      await actor.send(content: 'Consulta');
      expect(actor.status, AiConsultationStatus.error);
      expect(actor.failure, isA<NetworkFailure>());
    });

    test('lastResponse is null after error', () async {
      repo.willReturn(const Err(ServerFailure()));
      await actor.send(content: 'Consulta');
      expect(actor.lastResponse, isNull);
    });
  });

  group('AiConsultationActor — validation errors', () {
    test(
      'transitions to error on ValidationFailure for empty content',
      () async {
        // Empty content triggers use-case validation before repo is called.
        await actor.send(content: '');

        expect(actor.status, AiConsultationStatus.error);
        expect(actor.failure, isA<ValidationFailure>());
      },
    );

    test(
      'transitions to error on ValidationFailure for whitespace-only',
      () async {
        await actor.send(content: '   ');

        expect(actor.status, AiConsultationStatus.error);
        expect(actor.failure, isA<ValidationFailure>());
        expect(actor.failure?.message, 'Escribe un mensaje.');
      },
    );
  });

  group('AiConsultationActor — reset', () {
    test('reset returns to idle and clears failure', () async {
      repo.willReturn(const Err(ServerFailure()));
      await actor.send(content: 'Consulta');

      actor.reset();

      expect(actor.status, AiConsultationStatus.idle);
      expect(actor.failure, isNull);
    });

    test('reset clears lastResponse', () async {
      repo.willReturn(Ok(_sampleResponse()));
      await actor.send(content: 'Consulta');
      expect(actor.lastResponse, isNotNull);

      actor.reset();

      expect(actor.lastResponse, isNull);
    });
  });

  group('AiConsultationActor — notifyListeners', () {
    test('notifies listeners on each state change', () async {
      repo.willReturn(Ok(_sampleResponse()));

      var notifyCount = 0;
      actor.addListener(() => notifyCount++);

      await actor.send(content: 'Consulta');

      // Expect at least 2 notifications (sending + success).
      expect(notifyCount, greaterThanOrEqualTo(2));
    });
  });
}
