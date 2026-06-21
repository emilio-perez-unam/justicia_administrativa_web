// Tests for CalendarView — verifies that the calendar entries read gains proper
// error+retry states via FutureResultView.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/calendar_view.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';
import 'package:justicia_administrativa_site/domains/portal_calendar/application/use_cases/load_calendar_entries_use_case.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(height: 800, width: 1000, child: child)),
);

void main() {
  // Calendar entries read (read #6)
  group('CalendarView entries read', () {
    testWidgets('shows Reintentar when entries loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          CalendarView(
            entriesLoaderOverride: (_) async => throw TimeoutException('x'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when entries are empty', (tester) async {
      await tester.pumpWidget(
        _wrap(
          CalendarView(
            entriesLoaderOverride: (_) async => PortalCalendarEntries.empty,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No hay eventos ni tareas.'), findsOneWidget);
    });
  });
}
