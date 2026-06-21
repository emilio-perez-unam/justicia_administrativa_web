// Tests for DashboardView — verifies that the portal-stats and recent-matters
// reads gain proper error+retry states via FutureResultView.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/dashboard_view.dart';
import 'package:justicia_administrativa_site/core/models/calendar_event.dart';
import 'package:justicia_administrativa_site/core/models/matter.dart';
import 'package:justicia_administrativa_site/core/models/portal_message.dart';
import 'package:justicia_administrativa_site/core/models/portal_stats.dart';
import 'package:justicia_administrativa_site/core/models/task.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

const _stats = PortalStats(
  activeMatters: 3,
  totalDocuments: 10,
  upcomingEvents: 2,
  pendingInvoices: 1,
);

/// No-op stubs for the unrelated futures (messages/events/tasks).
/// These prevent PortalService from hitting the fake Supabase endpoint.
Future<List<PortalMessage>> _noMessages() async => [];
Future<List<CalendarEvent>> _noEvents() async => [];
Future<List<Task>> _noTasks() async => [];

PortalMessage _message(String id) => PortalMessage(
  id: id,
  senderId: 'sender-1',
  senderType: 'client',
  content: 'Mensaje de prueba $id',
  isRead: false,
  createdAt: DateTime(2025, 1, 1),
  senderName: 'Juan Pérez',
);

CalendarEvent _event(String id) => CalendarEvent(
  id: id,
  clientId: 'c1',
  title: 'Audiencia $id',
  eventType: 'audiencia',
  eventDate: DateTime(2025, 6, 15),
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

const _sharedPrefsChannel = MethodChannel(
  'plugins.flutter.io/shared_preferences',
);

Future<void> _initSupabase() async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_sharedPrefsChannel, (call) async {
        if (call.method == 'getAll') return <String, Object>{};
        return true;
      });
  try {
    Supabase.instance.client;
  } catch (_) {
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc3QiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTY4MDAwMDAwMCwiZXhwIjoyMDAwMDAwMDAwfQ.'
          'testsignature',
    );
  }
}

void main() {
  setUpAll(() async {
    await _initSupabase();
  });

  // -------------------------------------------------------------------------
  // Stats read (read #1)
  // -------------------------------------------------------------------------

  group('DashboardView stats read', () {
    testWidgets('shows Reintentar when stats loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => throw TimeoutException('x'),
            mattersLoaderOverride: () async => <Matter>[_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      // Let the future complete.
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows stats when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => <Matter>[_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Stats cards should appear with non-null values.
      expect(find.text('Asuntos Activos'), findsAtLeastNWidgets(1));
      // No Reintentar button in the success path.
      expect(find.text('Reintentar'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // Matters read (read #2)
  // -------------------------------------------------------------------------

  group('DashboardView matters read', () {
    testWidgets('shows Reintentar when matters loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => throw TimeoutException('x'),
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
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
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => <Matter>[],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No hay asuntos recientes.'), findsOneWidget);
    });

    testWidgets('shows matters table when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1), _matter(2)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Asunto 1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // Messages read (defect 1 — formerly dead future)
  // -------------------------------------------------------------------------

  group('DashboardView messages read', () {
    testWidgets('shows Reintentar when messages loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: () async => throw Exception('network'),
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when messages list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('No tienes mensajes.'), findsOneWidget);
    });

    testWidgets('shows message rows when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: () async => [_message('m1')],
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // Calendar read (defect 2 — formerly dead future)
  // -------------------------------------------------------------------------

  group('DashboardView calendar read', () {
    testWidgets('shows Reintentar when events loader throws', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: () async => throw Exception('timeout'),
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when events list is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: _noEvents,
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Sin eventos próximos.'), findsOneWidget);
    });

    testWidgets('shows event rows when loader returns data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          DashboardView(
            onNavigate: (_) {},
            statsLoaderOverride: () async => _stats,
            mattersLoaderOverride: () async => [_matter(1)],
            messagesLoaderOverride: _noMessages,
            eventsLoaderOverride: () async => [_event('e1')],
            tasksLoaderOverride: _noTasks,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Audiencia e1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
