// Widget tests for MessagesThreadPanel — verifies FutureResultView integration
// for the messages read.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/messages/messages_thread_panel.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
import 'package:justicia_administrativa_site/core/models/portal_message.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

Matter _matter(String id) => Matter(
  id: id,
  clientId: 'c1',
  referenceCode: 'REF-$id',
  title: 'Asunto $id',
  matterType: MatterType.consulta,
  status: MatterStatus.enProceso,
  lastUpdate: DateTime(2025),
  createdAt: DateTime(2025),
);

PortalMessage _message(String id) => PortalMessage(
  id: id,
  senderId: 'sender-1',
  senderType: 'client',
  content: 'Contenido del mensaje $id',
  isRead: false,
  createdAt: DateTime(2025, 1, 1),
);

MessagesThreadPanel _panel({
  required Future<List<PortalMessage>> Function()? messagesLoader,
  Future<List<Matter>> Function()? mattersLoader,
}) {
  final controller = TextEditingController();
  final scroll = ScrollController();
  return MessagesThreadPanel(
    mattersLoader: mattersLoader ?? () async => [_matter('m1')],
    messagesLoader: messagesLoader,
    selectedMatterId: 'm1',
    currentUserId: 'sender-1',
    messageController: controller,
    scrollController: scroll,
    onSendMessage: () {},
    onStartVoiceCall: () {},
    onStartVideoCall: () {},
    onPickAttachment: () {},
    onClearAttachment: () {},
  );
}

void main() {
  group('MessagesThreadPanel messages read', () {
    testWidgets('shows Reintentar when messages loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(_panel(messagesLoader: () async => throw Exception('network'))),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows empty state when messages list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_panel(messagesLoader: () async => <PortalMessage>[])),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.text('No hay mensajes en esta conversación.'),
        findsOneWidget,
      );
    });

    testWidgets('shows message bubbles when loader returns data', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_panel(messagesLoader: () async => [_message('msg1')])),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Contenido del mensaje msg1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
