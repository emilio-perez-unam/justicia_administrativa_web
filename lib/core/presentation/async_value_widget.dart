import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:justicia_administrativa_site/core/error/failure_mapper.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_empty_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_error_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_loading_state.dart';

/// A [StatelessWidget] that maps a Riverpod [AsyncValue] to the three explicit
/// UI states: loading, error-with-retry, and data (which may be empty).
///
/// Eliminates "happy path only" patterns by forcing the caller to handle all
/// branches:
///
/// | AsyncValue state  | Widget shown                                     |
/// |-------------------|--------------------------------------------------|
/// | loading           | [AppLoadingState] (or [loadingBuilder])          |
/// | error             | [AppErrorState] with optional retry button       |
/// | data + isEmpty    | [AppEmptyState] with [emptyMessage]              |
/// | data + !isEmpty   | [data] builder result                            |
///
/// ```dart
/// AsyncValueWidget<List<Case>>(
///   value: ref.watch(casesProvider),
///   isEmpty: (cases) => cases.isEmpty,
///   onRetry: () => ref.invalidate(casesProvider),
///   data: (ctx, cases) => CaseListWidget(cases: cases),
/// )
/// ```
class AsyncValueWidget<T> extends StatelessWidget {
  /// Creates an async-value-driven widget.
  ///
  /// [value] — the current [AsyncValue] from a Riverpod provider.
  /// [data] — builder for the success state when data is present.
  /// [isEmpty] — optional predicate; when true shows [AppEmptyState].
  /// [onRetry] — callback wired to the "Reintentar" button on error.
  /// [loadingBuilder] — optional override for the loading widget.
  /// [emptyMessage] — Spanish message shown in [AppEmptyState].
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.isEmpty,
    this.onRetry,
    this.loadingBuilder,
    this.emptyMessage = 'No hay información para mostrar.',
  });

  /// The Riverpod async state to render.
  final AsyncValue<T> value;

  /// Builds the success widget when data is non-empty (or isEmpty is null).
  final Widget Function(BuildContext, T) data;

  /// Returns `true` when the data should be treated as empty.
  /// If `null`, [data] is always called for the data state.
  final bool Function(T)? isEmpty;

  /// Callback invoked when the user taps "Reintentar" on the error state.
  /// When `null`, no retry button is rendered.
  final VoidCallback? onRetry;

  /// Optional override for the loading state widget.
  final WidgetBuilder? loadingBuilder;

  /// Spanish message for the empty state.
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) {
        if (isEmpty?.call(d) == true) {
          return AppEmptyState(message: emptyMessage);
        }
        return data(context, d);
      },
      loading: () => loadingBuilder?.call(context) ?? const AppLoadingState(),
      error: (e, st) =>
          AppErrorState(failure: mapErrorToFailure(e, st), onRetry: onRetry),
    );
  }
}
