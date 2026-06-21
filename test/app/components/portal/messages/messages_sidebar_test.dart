// Widget tests for MessagesSidebar — verifies FutureResultView integration.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/messages/messages_sidebar.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
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

void main() {
  group('MessagesSidebar', () {
    testWidgets('shows Reintentar when matters loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MessagesSidebar(
            mattersLoader: () async => throw Exception('network error'),
            selectedMatterId: null,
            isDesktop: true,
            onMatterSelected: (_) {},
            onCompose: () {},
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when matters list is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MessagesSidebar(
            mattersLoader: () async => <Matter>[],
            selectedMatterId: null,
            isDesktop: true,
            onMatterSelected: (_) {},
            onCompose: () {},
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('No hay conversaciones.'), findsOneWidget);
    });

    testWidgets('shows matter tiles when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MessagesSidebar(
            mattersLoader: () async => [_matter('m1'), _matter('m2')],
            selectedMatterId: null,
            isDesktop: true,
            onMatterSelected: (_) {},
            onCompose: () {},
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Asunto m1'), findsOneWidget);
      expect(find.text('Asunto m2'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
