import 'dart:async' show TimeoutException;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justicia_administrativa_site/core/presentation/async_value_widget.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_empty_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_error_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_loading_state.dart';

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // Helper
  // ──────────────────────────────────────────────────────────────────────────
  Widget wrap(Widget child) => ProviderScope(
    child: MaterialApp(home: Scaffold(body: child)),
  );

  // ──────────────────────────────────────────────────────────────────────────
  // LOADING state
  // ──────────────────────────────────────────────────────────────────────────
  group('AsyncValueWidget — loading', () {
    testWidgets('AsyncValue.loading() → shows AppLoadingState', (tester) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<String>(
            value: const AsyncValue.loading(),
            data: (_, d) => Text(d),
          ),
        ),
      );

      expect(find.byType(AppLoadingState), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading with custom loadingBuilder', (tester) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<String>(
            value: const AsyncValue.loading(),
            data: (_, d) => Text(d),
            loadingBuilder: (_) => const Text('custom-loader'),
          ),
        ),
      );

      expect(find.text('custom-loader'), findsOneWidget);
      expect(find.byType(AppLoadingState), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // ERROR state
  // ──────────────────────────────────────────────────────────────────────────
  group('AsyncValueWidget — error', () {
    testWidgets(
      'AsyncValue.error(TimeoutException) → shows NetworkFailure message + Reintentar',
      (tester) async {
        var retried = false;

        await tester.pumpWidget(
          wrap(
            AsyncValueWidget<String>(
              value: AsyncValue.error(
                TimeoutException('t'),
                StackTrace.current,
              ),
              data: (_, d) => Text(d),
              onRetry: () => retried = true,
            ),
          ),
        );

        expect(find.byType(AppErrorState), findsOneWidget);
        expect(
          find.text('Sin conexión. Revisa tu red e inténtalo de nuevo.'),
          findsOneWidget,
        );
        expect(find.text('Reintentar'), findsOneWidget);

        await tester.tap(find.text('Reintentar'));
        expect(retried, isTrue);
      },
    );

    testWidgets('error with no onRetry → no Reintentar button', (tester) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<String>(
            value: AsyncValue.error(TimeoutException('t'), StackTrace.current),
            data: (_, d) => Text(d),
          ),
        ),
      );

      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // EMPTY state
  // ──────────────────────────────────────────────────────────────────────────
  group('AsyncValueWidget — empty', () {
    testWidgets(
      'AsyncValue.data([]) with isEmpty → shows AppEmptyState with default message',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            AsyncValueWidget<List<int>>(
              value: const AsyncValue.data([]),
              isEmpty: (list) => list.isEmpty,
              data: (_, d) => Text('${d.length}'),
            ),
          ),
        );

        expect(find.byType(AppEmptyState), findsOneWidget);
        expect(find.text('No hay información para mostrar.'), findsOneWidget);
      },
    );

    testWidgets('empty with custom emptyMessage', (tester) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<List<int>>(
            value: const AsyncValue.data([]),
            isEmpty: (list) => list.isEmpty,
            emptyMessage: 'Nada que mostrar aquí.',
            data: (_, d) => Text('${d.length}'),
          ),
        ),
      );

      expect(find.text('Nada que mostrar aquí.'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // DATA state
  // ──────────────────────────────────────────────────────────────────────────
  group('AsyncValueWidget — data', () {
    testWidgets('AsyncValue.data([1]) → renders data widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<List<int>>(
            value: const AsyncValue.data([1]),
            isEmpty: (list) => list.isEmpty,
            data: (_, d) => Text('count: ${d.length}'),
          ),
        ),
      );

      expect(find.text('count: 1'), findsOneWidget);
      expect(find.byType(AppLoadingState), findsNothing);
      expect(find.byType(AppErrorState), findsNothing);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('non-empty data without isEmpty → renders builder', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<String>(
            value: const AsyncValue.data('hello'),
            data: (_, d) => Text(d),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('data with isEmpty=null → always forwards to builder', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          AsyncValueWidget<List<int>>(
            value: const AsyncValue.data([]),
            data: (_, d) => Text('list-empty: ${d.isEmpty}'),
          ),
        ),
      );

      // No isEmpty provided → builder always called, even with empty list.
      expect(find.text('list-empty: true'), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // All four states in sequence via mutable widget
  // ──────────────────────────────────────────────────────────────────────────
  group('AsyncValueWidget — state sequence', () {
    testWidgets('switches states as value changes', (tester) async {
      AsyncValue<String> currentValue = const AsyncValue.loading();

      Widget buildWithValue(AsyncValue<String> v) => wrap(
        AsyncValueWidget<String>(
          value: v,
          data: (_, d) => Text(d),
          onRetry: () {},
        ),
      );

      await tester.pumpWidget(buildWithValue(currentValue));
      expect(find.byType(AppLoadingState), findsOneWidget);

      // Transition to error
      currentValue = AsyncValue.error(TimeoutException('e'), StackTrace.empty);
      await tester.pumpWidget(buildWithValue(currentValue));
      expect(find.byType(AppErrorState), findsOneWidget);

      // Transition to data
      currentValue = const AsyncValue.data('done');
      await tester.pumpWidget(buildWithValue(currentValue));
      expect(find.text('done'), findsOneWidget);
    });
  });
}
