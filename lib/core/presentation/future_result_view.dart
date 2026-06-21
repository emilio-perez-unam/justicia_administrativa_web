import 'package:flutter/material.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';
import 'package:justicia_administrativa_site/core/error/failure_mapper.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_empty_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_error_state.dart';
import 'package:justicia_administrativa_site/core/presentation/states/app_loading_state.dart';

/// A [StatefulWidget] that drives the full async-state lifecycle for a single
/// [Future]-backed data load.
///
/// Every read goes through three explicit states so the UI can never silently
/// swallow an error or display a blank screen:
///
/// | State   | Widget shown                                 |
/// |---------|----------------------------------------------|
/// | waiting | [AppLoadingState] (or [loadingBuilder])      |
/// | error   | [AppErrorState] with retry (or [errorBuilder]) |
/// | empty   | [AppEmptyState] when [isEmpty] returns true  |
/// | data    | [builder] with the resolved value            |
///
/// ```dart
/// FutureResultView<List<Case>>(
///   loader: () => caseRepo.fetchOpen(),
///   isEmpty: (cases) => cases.isEmpty,
///   builder: (ctx, cases) => CaseListWidget(cases: cases),
/// )
/// ```
class FutureResultView<T> extends StatefulWidget {
  /// Creates a future-backed view.
  ///
  /// [loader] is called on [initState] and again on every retry.
  /// [builder] receives the resolved data when [isEmpty] is false or absent.
  /// [isEmpty] determines whether to show [AppEmptyState] instead of [builder].
  /// [loadingBuilder] overrides the default [AppLoadingState].
  /// [errorBuilder] overrides the default [AppErrorState] with retry button.
  const FutureResultView({
    super.key,
    required this.loader,
    required this.builder,
    this.isEmpty,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// Provides the [Future] whose result this widget renders.
  ///
  /// Called once on init and again each time the user taps "Reintentar".
  final Future<T> Function() loader;

  /// Builds the success widget for non-empty data.
  final Widget Function(BuildContext, T) builder;

  /// Returns `true` when the resolved data should be treated as empty.
  /// If `null`, data is always forwarded to [builder].
  final bool Function(T)? isEmpty;

  /// Optional override for the waiting/loading state widget.
  final WidgetBuilder? loadingBuilder;

  /// Optional override for the error state widget.
  ///
  /// Receives [BuildContext], the mapped [Failure], and the retry callback.
  final Widget Function(BuildContext, Failure, VoidCallback retry)?
  errorBuilder;

  @override
  State<FutureResultView<T>> createState() => _FutureResultViewState<T>();
}

class _FutureResultViewState<T> extends State<FutureResultView<T>> {
  Future<T>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.loader();
  }

  /// Replaces [_future] with a fresh invocation of [widget.loader], which
  /// causes [FutureBuilder] to transition back to the loading state.
  void _retry() {
    setState(() {
      _future = widget.loader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snap) {
        // ── Waiting / not yet started ────────────────────────────────────
        if (snap.connectionState == ConnectionState.waiting ||
            snap.connectionState == ConnectionState.none) {
          return widget.loadingBuilder?.call(context) ??
              const AppLoadingState();
        }

        // ── Error ────────────────────────────────────────────────────────
        if (snap.hasError) {
          final failure = mapErrorToFailure(snap.error!, snap.stackTrace);
          return widget.errorBuilder?.call(context, failure, _retry) ??
              AppErrorState(failure: failure, onRetry: _retry);
        }

        // ── Data: empty check ────────────────────────────────────────────
        if (snap.hasData) {
          final data = snap.data as T;
          if (widget.isEmpty?.call(data) == true) {
            return const AppEmptyState(
              message: 'No hay información para mostrar.',
            );
          }
          return widget.builder(context, data);
        }

        // ── Fallback (done with no data and no error — e.g. Future<void>) ─
        return widget.loadingBuilder?.call(context) ?? const AppLoadingState();
      },
    );
  }
}
