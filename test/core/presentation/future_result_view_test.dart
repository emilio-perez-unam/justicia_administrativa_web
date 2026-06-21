import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/presentation/future_result_view.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_empty_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_error_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_loading_state.dart';

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // Helper: wrap widget in MaterialApp / Scaffold
  // ──────────────────────────────────────────────────────────────────────────
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  // ──────────────────────────────────────────────────────────────────────────
  // LOADING state
  // ──────────────────────────────────────────────────────────────────────────
  group('FutureResultView — loading', () {
    testWidgets('shows AppLoadingState while future is pending', (
      tester,
    ) async {
      // Use a Completer so the future never resolves during this test.
      final completer = Completer<List<int>>();

      await tester.pumpWidget(
        wrap(
          FutureResultView<List<int>>(
            loader: () => completer.future,
            builder: (_, data) => Text('data: ${data.length}'),
          ),
        ),
      );

      // Don't pump to resolve — still in waiting state.
      expect(find.byType(AppLoadingState), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses custom loadingBuilder when provided', (tester) async {
      final completer = Completer<List<int>>();

      await tester.pumpWidget(
        wrap(
          FutureResultView<List<int>>(
            loader: () => completer.future,
            builder: (_, data) => Text('${data.length}'),
            loadingBuilder: (_) => const Text('custom-loading'),
          ),
        ),
      );

      expect(find.text('custom-loading'), findsOneWidget);
      expect(find.byType(AppLoadingState), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // ERROR state
  // ──────────────────────────────────────────────────────────────────────────
  group('FutureResultView — error', () {
    testWidgets(
      'shows AppErrorState with NetworkFailure message for TimeoutException',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            FutureResultView<List<int>>(
              loader: () async => throw TimeoutException('t'),
              builder: (_, data) => Text('${data.length}'),
            ),
          ),
        );

        // Pump past the microtask / future completion.
        await tester.pump();
        await tester.pump();

        expect(find.byType(AppErrorState), findsOneWidget);
        // NetworkFailure default message
        expect(
          find.text('Sin conexión. Revisa tu red e inténtalo de nuevo.'),
          findsOneWidget,
        );
        expect(find.text('Reintentar'), findsOneWidget);
      },
    );

    testWidgets('tapping Reintentar re-invokes loader', (tester) async {
      var callCount = 0;
      // Second call completer: stays pending so the test just verifies
      // the count without needing to resolve a second future.
      final secondCompleter = Completer<String>();

      await tester.pumpWidget(
        wrap(
          FutureResultView<String>(
            loader: () {
              callCount++;
              if (callCount == 1) {
                // First call: return a future that will error after pump.
                return Future.error(TimeoutException('fail'));
              }
              return secondCompleter.future;
            },
            builder: (_, d) => Text(d),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      expect(callCount, 1);
      expect(find.byType(AppErrorState), findsOneWidget);

      await tester.tap(find.text('Reintentar'));
      await tester.pump(); // trigger setState → new future assigned
      expect(callCount, 2);
      // Widget is now in loading state (second future still pending)
      expect(find.byType(AppLoadingState), findsOneWidget);
    });

    testWidgets('uses custom errorBuilder when provided', (tester) async {
      await tester.pumpWidget(
        wrap(
          FutureResultView<String>(
            loader: () async => throw TimeoutException('x'),
            builder: (_, d) => Text(d),
            errorBuilder: (_, failure, retry) =>
                Text('custom-error: ${failure.message}'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.textContaining('custom-error:'), findsOneWidget);
      expect(find.byType(AppErrorState), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // EMPTY state
  // ──────────────────────────────────────────────────────────────────────────
  group('FutureResultView — empty', () {
    testWidgets('shows AppEmptyState when isEmpty returns true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          FutureResultView<List<int>>(
            loader: () async => <int>[],
            isEmpty: (list) => list.isEmpty,
            builder: (_, data) => Text('${data.length}'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text('No hay información para mostrar.'), findsOneWidget);
      expect(find.byType(AppErrorState), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // DATA state
  // ──────────────────────────────────────────────────────────────────────────
  group('FutureResultView — data', () {
    testWidgets('shows builder output when loader returns data', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          FutureResultView<List<int>>(
            loader: () async => [1, 2, 3],
            builder: (_, data) => Text('count: ${data.length}'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('count: 3'), findsOneWidget);
      expect(find.byType(AppLoadingState), findsNothing);
      expect(find.byType(AppErrorState), findsNothing);
    });

    testWidgets('does not treat non-empty list as empty', (tester) async {
      await tester.pumpWidget(
        wrap(
          FutureResultView<List<int>>(
            loader: () async => [42],
            isEmpty: (list) => list.isEmpty,
            builder: (_, data) => Text('${data.first}'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('retry succeeds on second call and shows data', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        wrap(
          FutureResultView<String>(
            loader: () async {
              calls++;
              if (calls == 1) throw TimeoutException('first-fail');
              return 'success';
            },
            builder: (_, d) => Text(d),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // First call failed — should see error state
      expect(find.byType(AppErrorState), findsOneWidget);
      expect(calls, 1);

      // Tap retry — second call succeeds
      await tester.tap(find.text('Reintentar'));
      await tester.pump(); // rebuild with new future
      await tester.pumpAndSettle(); // resolve future

      expect(find.text('success'), findsOneWidget);
      expect(find.byType(AppErrorState), findsNothing);
      expect(calls, 2);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // TRANSITION: loading → data
  // ──────────────────────────────────────────────────────────────────────────
  group('FutureResultView — state transitions', () {
    testWidgets('transitions from loading to data', (tester) async {
      final completer = Completer<String>();

      await tester.pumpWidget(
        wrap(
          FutureResultView<String>(
            loader: () => completer.future,
            builder: (_, d) => Text(d),
          ),
        ),
      );

      // Initially loading
      expect(find.byType(AppLoadingState), findsOneWidget);

      // Complete the future
      completer.complete('hello');
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);
      expect(find.byType(AppLoadingState), findsNothing);
    });
  });
}
