// Tests for MattersList — verifies that the matters read gains proper
// loading / empty / error+retry states via FutureResultView, and that retry
// actually re-invokes the loader (a real re-fetch, not a re-await of a dead
// future).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/matters/matters_list.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
import 'package:justicia_administrativa_site/core/services/fuzzy_search_service.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps a [child] inside a CustomScrollView since MattersList returns slivers.
Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(
    body: SizedBox(
      height: 600,
      width: 800,
      child: CustomScrollView(slivers: [child]),
    ),
  ),
);

Matter _matter(int i) => Matter(
  id: 'id$i',
  clientId: 'c1',
  referenceCode: 'REF-00$i',
  title: 'Asunto $i',
  matterType: MatterType.consulta,
  status: MatterStatus.enProceso,
  lastUpdate: DateTime(2025),
  createdAt: DateTime(2025),
);

MattersList _list({
  required Future<List<Matter>> Function() loader,
  String searchQuery = '',
  String statusFilter = 'Todos',
}) => MattersList(
  mattersLoader: loader,
  fuzzySearch: FuzzySearchService(),
  searchQuery: searchQuery,
  statusFilter: statusFilter,
  onPreviewReport: (_) {},
  onShowDetail: (_) {},
);

void main() {
  group('MattersList matters read', () {
    testWidgets('shows Reintentar when the matters loader throws', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _list(
            loader: () => Future<List<Matter>>.delayed(
              Duration.zero,
              () => throw TimeoutException('x'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets(
      'shows empty state when matters list is empty after filtering',
      (tester) async {
        await tester.pumpWidget(_wrap(_list(loader: () async => <Matter>[])));
        await tester.pump();
        await tester.pump();

        expect(find.text('No hay asuntos.'), findsOneWidget);
      },
    );

    testWidgets('shows matter cards when the loader returns data', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_list(loader: () async => [_matter(1)])));
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Asunto 1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('Reintentar re-invokes the loader and recovers from error', (
      tester,
    ) async {
      var calls = 0;
      Future<List<Matter>> loader() async {
        calls++;
        if (calls == 1) throw TimeoutException('first attempt');
        return [_matter(1)];
      }

      await tester.pumpWidget(_wrap(_list(loader: loader)));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Reintentar'), findsOneWidget);
      expect(calls, 1);

      await tester.tap(find.text('Reintentar'));
      await tester.pump(); // retry kicks off a fresh loader() call
      await tester.pump();
      await tester.pumpAndSettle();

      // Proves the retry performed a real re-fetch (not a re-await of the
      // already-failed future) and recovered to the data state.
      expect(calls, 2);
      expect(find.text('Asunto 1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
