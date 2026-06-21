import 'package:flutter/material.dart';
import 'package:justicia_administrativa_site/core/error/failure.dart';

/// Centered error display: icon, failure message, and an optional retry button.
///
/// Pass [onRetry] to display an [OutlinedButton] labeled "Reintentar".
/// Set [compact] to `true` for inline/card usage where full padding is
/// inappropriate (e.g., inside a list item or small card).
class AppErrorState extends StatelessWidget {
  /// Creates an error state widget.
  ///
  /// [failure] provides the human-readable Spanish message.
  /// [onRetry] — when non-null a "Reintentar" button is shown.
  /// [compact] — reduces padding and icon size for inline use.
  const AppErrorState({
    super.key,
    required this.failure,
    this.onRetry,
    this.compact = false,
  });

  /// The domain failure surfaced from the repository or data layer.
  final Failure failure;

  /// Callback invoked when the user taps the "Reintentar" button.
  /// If `null`, no retry button is rendered.
  final VoidCallback? onRetry;

  /// When `true`, reduces padding and icon size for inline/card contexts.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = compact ? 32.0 : 56.0;
    final padding = compact ? 16.0 : 32.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: iconSize,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: compact ? 8 : 16),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              SizedBox(height: compact ? 8 : 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
