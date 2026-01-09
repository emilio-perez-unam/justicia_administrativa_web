
import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/utils/responsive_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BreakpointType breakpoint) builder;

  const ResponsiveBuilder({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = context.breakpoint; // Using the extension
        return builder(context, breakpoint);
      },
    );
  }
}
