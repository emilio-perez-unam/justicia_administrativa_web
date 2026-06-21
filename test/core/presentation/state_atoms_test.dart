import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_loading_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_empty_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_error_state.dart';

/// Tests for the three atomic state widgets:
/// [AppLoadingState], [AppEmptyState], [AppErrorState].
void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // AppLoadingState
  // ──────────────────────────────────────────────────────────────────────────
  group('AppLoadingState', () {
    testWidgets('renders a CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLoadingState())),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses default semantic label "Cargando"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AppLoadingState())),
      );
      expect(find.bySemanticsLabel('Cargando'), findsOneWidget);
    });

    testWidgets('accepts a custom semantic label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoadingState(semanticLabel: 'Procesando')),
        ),
      );
      expect(find.bySemanticsLabel('Procesando'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AppEmptyState
  // ──────────────────────────────────────────────────────────────────────────
  group('AppEmptyState', () {
    testWidgets('shows message text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmptyState(message: 'Lista vacía')),
        ),
      );
      expect(find.text('Lista vacía'), findsOneWidget);
    });

    testWidgets('shows default icon (Icons.inbox_outlined)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmptyState(message: 'x')),
        ),
      );
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('shows custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyState(message: 'x', icon: Icons.search_off),
          ),
        ),
      );
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('shows optional action widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEmptyState(
              message: 'x',
              action: ElevatedButton(
                onPressed: () {},
                child: const Text('Acción'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Acción'), findsOneWidget);
    });

    testWidgets('renders without action widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmptyState(message: 'Nada')),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AppErrorState
  // ──────────────────────────────────────────────────────────────────────────
  group('AppErrorState', () {
    const failure = NetworkFailure(
      message: 'Sin conexión. Revisa tu red e inténtalo de nuevo.',
    );

    testWidgets('shows failure.message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorState(failure: failure)),
        ),
      );
      expect(find.text(failure.message), findsOneWidget);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorState(failure: failure)),
        ),
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows Reintentar button when onRetry is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorState(failure: failure, onRetry: () {}),
          ),
        ),
      );
      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('tapping Reintentar calls onRetry callback', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorState(failure: failure, onRetry: () => called++),
          ),
        ),
      );
      await tester.tap(find.text('Reintentar'));
      expect(called, 1);
    });

    testWidgets('does NOT show Reintentar button when onRetry is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorState(failure: failure)),
        ),
      );
      expect(find.text('Reintentar'), findsNothing);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('compact=true renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorState(failure: failure, compact: true)),
        ),
      );
      expect(find.text(failure.message), findsOneWidget);
    });

    testWidgets('compact=true with onRetry shows button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorState(
              failure: failure,
              onRetry: () {},
              compact: true,
            ),
          ),
        ),
      );
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}
