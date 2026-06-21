// Tests for DocumentsView — verifies that the documents read gains proper
// error+retry states via FutureResultView.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/documents_view.dart';
import 'package:justicia_administrativa_site/core/models/document.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(height: 600, width: 800, child: child)),
);

Document _doc(int i) => Document(
  id: 'doc$i',
  clientId: 'c1',
  name: 'Documento $i.pdf',
  category: DocumentCategory.otro,
  createdAt: DateTime(2025, 1, i + 1),
);

void main() {
  // Documents read (read #3)
  group('DocumentsView documents read', () {
    testWidgets('shows Reintentar when documents loader throws', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DocumentsView(
            documentsLoaderOverride: () async => throw TimeoutException('x'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when documents list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(DocumentsView(documentsLoaderOverride: () async => <Document>[])),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No hay documentos.'), findsOneWidget);
    });

    testWidgets('shows document cards when loader returns data', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DocumentsView(
            documentsLoaderOverride: () async => [_doc(0), _doc(1)],
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      // Settle animations (flutter_animate on _DocumentCard).
      await tester.pumpAndSettle();

      expect(find.text('Documento 0.pdf'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
