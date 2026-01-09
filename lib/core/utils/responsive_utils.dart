
import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/shared/widgets/responsive_layout.dart'; // For breakpoints

enum BreakpointType { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < ResponsiveLayout.mobileBreakpoint;
  bool get isTablet => screenWidth >= ResponsiveLayout.mobileBreakpoint && screenWidth < ResponsiveLayout.tabletBreakpoint;
  bool get isDesktop => screenWidth >= ResponsiveLayout.tabletBreakpoint;

  BreakpointType get breakpoint {
    if (isMobile) return BreakpointType.mobile;
    if (isTablet) return BreakpointType.tablet;
    return BreakpointType.desktop;
  }

  // Example for responsive spacing, tied to design tokens
  double responsiveSpacing(double baseValue, {double mobileFactor = 0.8, double tabletFactor = 1.0, double desktopFactor = 1.2}) {
    if (isMobile) return baseValue * mobileFactor;
    if (isTablet) return baseValue * tabletFactor;
    return baseValue * desktopFactor;
  }

  // Placeholder for responsive font size - will be refined in next step
  double responsiveFontSize(double baseSize) {
    // This is a basic linear scaling. Will be improved in the typography step.
    if (isMobile) return baseSize * 0.9;
    if (isTablet) return baseSize * 1.0;
    return baseSize * 1.1;
  }
}
