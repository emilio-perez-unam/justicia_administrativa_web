import 'package:flutter/material.dart';

/// Spacing system for Justicia Administrativa
/// Based on 8px grid system for consistency
class AppSpacing {
  // Base unit
  static const double unit = 8.0;

  // Spacing values
  static const double xs = unit * 0.5; // 4px
  static const double sm = unit; // 8px
  static const double md = unit * 2; // 16px
  static const double lg = unit * 3; // 24px
  static const double xl = unit * 4; // 32px
  static const double xxl = unit * 5; // 40px
  static const double xxxl = unit * 6; // 48px

  // Layout specific
  static const double headerHeight = 80.0;
  static const double maxContentWidth = 1440.0;
  static const double cardPadding = lg;
  static const double sectionPadding = xl;
  static const double pagePadding = lg;

  // Responsive breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Helper methods for responsive spacing
  static EdgeInsets get pagePaddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: pagePadding);

  static EdgeInsets get sectionPaddingAll =>
      const EdgeInsets.all(sectionPadding);

  static EdgeInsets get cardPaddingAll => const EdgeInsets.all(cardPadding);

  // Grid gaps
  static const double gridGap = xl; // 32px as specified

  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
}
