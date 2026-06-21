// Tests for PortalSidebarNavigation — verifies that the conversations read
// gains proper error+retry states via FutureResultView.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/app/components/portal/sidebar/portal_sidebar_navigation.dart';
import 'package:justicia_administrativa_site/core/models/conversation.dart';
import 'package:justicia_administrativa_site/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(height: 800, width: 300, child: child)),
);

Conversation _conv(int i) => Conversation(
  id: 'conv$i',
  userId: 'u1',
  title: 'Conversacion $i',
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

const _navyColor = Color(0xFF1E3A8A);
const _goldColor = Color(0xFFD4AF37);

const MethodChannel _sharedPrefsChannel = MethodChannel(
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

  // Conversations read (read #7)
  group('PortalSidebarNavigation conversations read', () {
    testWidgets('shows Reintentar when conversations loader throws', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          PortalSidebarNavigation(
            activeTab: 'Herramientas IA',
            onTabSelected: (_) {},
            navyColor: _navyColor,
            goldColor: _goldColor,
            conversationsLoaderOverride: () async =>
                throw TimeoutException('x'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('shows empty state when conversations list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          PortalSidebarNavigation(
            activeTab: 'Herramientas IA',
            onTabSelected: (_) {},
            navyColor: _navyColor,
            goldColor: _goldColor,
            conversationsLoaderOverride: () async => <Conversation>[],
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No hay conversaciones.'), findsOneWidget);
    });

    testWidgets('shows conversation tiles when loader returns data', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          PortalSidebarNavigation(
            activeTab: 'Herramientas IA',
            onTabSelected: (_) {},
            navyColor: _navyColor,
            goldColor: _goldColor,
            conversationsLoaderOverride: () async => [_conv(1), _conv(2)],
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Conversacion 1'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}
