import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/services/chat_service.dart';
import 'package:justicia_administrativa_site/core/models/message.dart';
import 'package:justicia_administrativa_site/domains/ai_consultation/application/ai_consultation_repository.dart';
import 'package:justicia_administrativa_site/domains/ai_consultation/application/send_consultation_message_use_case.dart';

// ---------------------------------------------------------------------------
// Fake repository for use-case tests.
// ---------------------------------------------------------------------------
class _FakeAiConsultationRepository implements AiConsultationRepository {
  Result<ChatResponse>? _nextResult;

  void willReturn(Result<ChatResponse> result) => _nextResult = result;

  @override
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    return _nextResult ??
        Ok(
          ChatResponse(
            conversationId: 'conv-1',
            message: Message(
              id: 'm-1',
              role: 'assistant',
              content: 'Respuesta de prueba.',
              createdAt: DateTime(2025),
            ),
          ),
        );
  }
}

// ---------------------------------------------------------------------------
// Shared fixture.
// ---------------------------------------------------------------------------
ChatResponse _sampleResponse() => ChatResponse(
  conversationId: 'conv-abc',
  message: Message(
    id: 'm-abc',
    role: 'assistant',
    content: 'Aquí está tu respuesta.',
    createdAt: DateTime(2025, 3, 1),
  ),
);

void main() {
  late _FakeAiConsultationRepository fakeRepo;
  late SendConsultationMessageUseCase useCase;

  setUp(() {
    fakeRepo = _FakeAiConsultationRepository();
    useCase = SendConsultationMessageUseCase(fakeRepo);
  });

  group('SendConsultationMessageUseCase — validation', () {
    test('returns ValidationFailure when content is empty', () async {
      final result = await useCase(content: '');

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<ValidationFailure>()),
      );
    });

    test('returns ValidationFailure when content is only whitespace', () async {
      final result = await useCase(content: '   ');

      expect(result.isErr, isTrue);
      result.fold((_) => fail('Expected Err'), (f) {
        expect(f, isA<ValidationFailure>());
        expect(f.message, 'Escribe un mensaje.');
      });
    });

    test('does not call repository for empty content', () async {
      var repoCalled = false;
      fakeRepo.willReturn(Ok(_sampleResponse()));

      // Override with a tracking repo by subclassing.
      final trackingRepo = _TrackingRepo(fakeRepo, () => repoCalled = true);
      final uc = SendConsultationMessageUseCase(trackingRepo);

      await uc(content: '');

      expect(repoCalled, isFalse);
    });
  });

  group('SendConsultationMessageUseCase — delegation to repository', () {
    test('returns Ok(ChatResponse) when repo succeeds', () async {
      final response = _sampleResponse();
      fakeRepo.willReturn(Ok(response));

      final result = await useCase(content: 'Mi consulta legal');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.conversationId, 'conv-abc');
    });

    test('returns Err(AuthFailure) when repo returns AuthFailure', () async {
      fakeRepo.willReturn(
        const Err(
          AuthFailure(message: 'Inicia sesión para usar el asistente de IA.'),
        ),
      );

      final result = await useCase(content: 'Consulta');

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('Expected Err'),
        (f) => expect(f, isA<AuthFailure>()),
      );
    });

    test(
      'returns Err(ServerFailure) when repo returns ServerFailure',
      () async {
        fakeRepo.willReturn(const Err(ServerFailure()));

        final result = await useCase(content: 'Consulta');

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('Expected Err'),
          (f) => expect(f, isA<ServerFailure>()),
        );
      },
    );

    test(
      'returns Err(NetworkFailure) when repo returns NetworkFailure',
      () async {
        fakeRepo.willReturn(const Err(NetworkFailure()));

        final result = await useCase(content: 'Consulta');

        expect(result.isErr, isTrue);
        result.fold(
          (_) => fail('Expected Err'),
          (f) => expect(f, isA<NetworkFailure>()),
        );
      },
    );

    test('passes parameters to repository', () async {
      final capturingRepo = _CapturingRepo();
      final uc = SendConsultationMessageUseCase(capturingRepo);

      await uc(
        content: 'Hola',
        conversationId: 'conv-xyz',
        webSearch: true,
        attachmentUrl: 'https://example.com/doc.pdf',
        attachmentName: 'doc.pdf',
      );

      expect(capturingRepo.lastContent, 'Hola');
      expect(capturingRepo.lastConversationId, 'conv-xyz');
      expect(capturingRepo.lastWebSearch, isTrue);
      expect(capturingRepo.lastAttachmentUrl, 'https://example.com/doc.pdf');
      expect(capturingRepo.lastAttachmentName, 'doc.pdf');
    });

    test('trims content before delegating to repository', () async {
      final capturingRepo = _CapturingRepo();
      final uc = SendConsultationMessageUseCase(capturingRepo);

      await uc(content: '  Mi consulta  ');

      expect(capturingRepo.lastContent, 'Mi consulta');
    });
  });
}

// ---------------------------------------------------------------------------
// Helper fake repos.
// ---------------------------------------------------------------------------

class _TrackingRepo implements AiConsultationRepository {
  final AiConsultationRepository _delegate;
  final void Function() _onCall;

  _TrackingRepo(this._delegate, this._onCall);

  @override
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) {
    _onCall();
    return _delegate.sendMessage(
      content: content,
      conversationId: conversationId,
      webSearch: webSearch,
      attachmentUrl: attachmentUrl,
      attachmentName: attachmentName,
    );
  }
}

class _CapturingRepo implements AiConsultationRepository {
  String? lastContent;
  String? lastConversationId;
  bool lastWebSearch = false;
  String? lastAttachmentUrl;
  String? lastAttachmentName;

  @override
  Future<Result<ChatResponse>> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    lastContent = content;
    lastConversationId = conversationId;
    lastWebSearch = webSearch;
    lastAttachmentUrl = attachmentUrl;
    lastAttachmentName = attachmentName;

    return Ok(
      ChatResponse(
        conversationId: 'conv-1',
        message: Message(
          id: 'm-1',
          role: 'assistant',
          content: 'OK',
          createdAt: DateTime(2025),
        ),
      ),
    );
  }
}
