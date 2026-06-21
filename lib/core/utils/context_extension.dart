import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  // Size shortcuts
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Breakpoints
  bool get isMobile => width < 640;
  bool get isTablet => width >= 640 && width < 1024;
  bool get isDesktop => width >= 1024;

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Spacing shortcuts (Standardized)
  double get spacingXs => 4.0;
  double get spacingSm => 8.0;
  double get spacingMd => 16.0;
  double get spacingLg => 24.0;
  double get spacingXl => 32.0;

  T responsive<T>(T defaultVal, {T? sm, T? md, T? lg, T? xl}) {
    if (width >= 1280 && xl != null) return xl;
    if (width >= 1024 && lg != null) return lg;
    if (width >= 768 && md != null) return md;
    if (width >= 640 && sm != null) return sm;
    return defaultVal;
  }
}
