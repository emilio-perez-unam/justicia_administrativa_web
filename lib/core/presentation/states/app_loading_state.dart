import 'package:flutter/material.dart';

/// Centered adaptive loading indicator, wrapped in [Semantics] for
/// screen-reader support.
///
/// Use as the loading arm of [FutureResultView] or [AsyncValueWidget].
/// A skeleton/shimmer variant may be layered on top later; this atom
/// intentionally stays minimal.
class AppLoadingState extends StatelessWidget {
  /// Creates a centered loading indicator.
  ///
  /// [semanticLabel] is announced by screen readers (default: 'Cargando').
  const AppLoadingState({super.key, this.semanticLabel = 'Cargando'});

  /// Screen-reader label announced while content is being fetched.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: semanticLabel,
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
