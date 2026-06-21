import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

const double kMaxWidth = 1200;

class SectionContainer extends StatelessWidget {
  final Color? background;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const SectionContainer({
    super.key,
    required this.child,
    this.background,
    this.padding = const EdgeInsets.fromLTRB(24, 96, 24, 96),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background ?? Colors.white,
      child: MaxWidth(padding: padding, child: child),
    );
  }
}

class MaxWidth extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const MaxWidth({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.maxWidth = kMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final bool center;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final align = center ? TextAlign.center : TextAlign.left;
    final crossAxis = center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: colors.primary, // Using primary for accent text
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: align,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colors.foreground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: align,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.mutedForeground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
