import 'package:flutter/material.dart';

/// Centered empty-state display: icon, message, and an optional action widget.
///
/// Rendered when a data load succeeds but returns zero items.  The icon and
/// text use muted (disabled-text) colors from the active [Theme] so they
/// never compete with primary UI.
class AppEmptyState extends StatelessWidget {
  /// Creates an empty-state widget.
  ///
  /// [message] is required — it must describe what is missing in product
  /// language (Spanish).  [icon] defaults to [Icons.inbox_outlined].
  /// [action] is an optional call-to-action placed below the message.
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  /// Human-readable explanation of why the list/content is empty.
  final String message;

  /// Leading icon that visually reinforces the empty state.
  final IconData icon;

  /// Optional widget (button, link, etc.) placed below the message.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: mutedColor),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: mutedColor),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
