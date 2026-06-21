import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/result.dart';
import 'package:justicia_administrativa_site/core/models/portal_message.dart';
import 'package:justicia_administrativa_site/domains/portal_messaging/application/load_recent_messages_use_case.dart';
import 'package:justicia_administrativa_site/domains/portal_messaging/application/portal_messaging_repository.dart';

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class _FakeRepo implements PortalMessagingRepository {
  final Result<List<PortalMessage>> result;

  const _FakeRepo(this.result);

  @override
  Future<Result<List<PortalMessage>>> recentMessages({int limit = 5}) async =>
      result;
}

// ---------------------------------------------------------------------------
// Helper builders
// ---------------------------------------------------------------------------

PortalMessage _message(String id) => PortalMessage(
  id: id,
  senderId: 'sender-1',
  senderType: 'client',
  content: 'Mensaje de prueba $id',
  isRead: false,
  createdAt: DateTime(2025, 1, 1),
);

void main() {
  group('LoadRecentMessagesUseCase', () {
    test('returns Ok with messages on repository success', () async {
      final messages = [_message('m1'), _message('m2')];
      final useCase = LoadRecentMessagesUseCase(_FakeRepo(Ok(messages)));

      final result = await useCase(limit: 5);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(2));
      expect(result.valueOrNull!.first.id, equals('m1'));
    });

    test('returns Ok with empty list when repository returns empty', () async {
      final useCase = LoadRecentMessagesUseCase(
        _FakeRepo(Ok(<PortalMessage>[])),
      );

      final result = await useCase(limit: 5);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns Err when repository returns failure', () async {
      const failure = NetworkFailure();
      final useCase = LoadRecentMessagesUseCase(
        _FakeRepo(Err<List<PortalMessage>>(failure)),
      );

      final result = await useCase(limit: 5);

      expect(result.isErr, isTrue);
      result.fold(
        (_) => fail('expected Err'),
        (f) => expect(f, isA<NetworkFailure>()),
      );
    });

    test('forwards the limit parameter to the repository', () async {
      var capturedLimit = 0;

      // Custom repo to capture the limit
      final repo = _LimitCapturingRepo(onCall: (l) => capturedLimit = l);
      final useCase = LoadRecentMessagesUseCase(repo);

      await useCase(limit: 3);

      expect(capturedLimit, equals(3));
    });
  });
}

class _LimitCapturingRepo implements PortalMessagingRepository {
  final void Function(int) onCall;

  const _LimitCapturingRepo({required this.onCall});

  @override
  Future<Result<List<PortalMessage>>> recentMessages({int limit = 5}) async {
    onCall(limit);
    return Ok(<PortalMessage>[]);
  }
}
