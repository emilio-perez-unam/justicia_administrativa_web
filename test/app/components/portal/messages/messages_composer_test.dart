// Tests for MessagesComposer — verifies the attachment affordance: the
// paperclip triggers the pick callback and the pending chip shows + clears.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/messages/messages_composer.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('paperclip triggers onPickAttachment', (tester) async {
    var picked = false;
    await tester.pumpWidget(
      _wrap(
        MessagesComposer(
          controller: TextEditingController(),
          onSendMessage: () {},
          onPickAttachment: () => picked = true,
          onClearAttachment: () {},
        ),
      ),
    );

    await tester.tap(find.byTooltip('Adjuntar archivo'));
    expect(picked, isTrue);
  });

  testWidgets('shows the pending attachment chip and its clear control works', (
    tester,
  ) async {
    var cleared = false;
    await tester.pumpWidget(
      _wrap(
        MessagesComposer(
          controller: TextEditingController(),
          onSendMessage: () {},
          onPickAttachment: () {},
          onClearAttachment: () => cleared = true,
          pendingAttachmentName: 'evidencia.pdf',
        ),
      ),
    );

    expect(find.text('evidencia.pdf'), findsOneWidget);

    // The chip's trailing "x" is the only LucideIcons.x in the tree.
    await tester.tap(find.byIcon(LucideIcons.x));
    expect(cleared, isTrue);
  });
}
