
import 'package:flutter/material.dart';

class AppResponsiveThemeExtension extends ThemeExtension<AppResponsiveThemeExtension> {
  final double Function(BuildContext) responsivePagePadding;
  final double Function(BuildContext) responsiveContentPadding;
  final TextStyle Function(BuildContext) displayLarge;
  final TextStyle Function(BuildContext) headingLarge;
  final TextStyle Function(BuildContext) bodyLarge;
  final TextStyle Function(BuildContext) button;

  const AppResponsiveThemeExtension({
    required this.responsivePagePadding,
    required this.responsiveContentPadding,
    required this.displayLarge,
    required this.headingLarge,
    required this.bodyLarge,
    required this.button,
  });

  @override
  AppResponsiveThemeExtension copyWith({
    double Function(BuildContext)? responsivePagePadding,
    double Function(BuildContext)? responsiveContentPadding,
    TextStyle Function(BuildContext)? displayLarge,
    TextStyle Function(BuildContext)? headingLarge,
    TextStyle Function(BuildContext)? bodyLarge,
    TextStyle Function(BuildContext)? button,
  }) {
    return AppResponsiveThemeExtension(
      responsivePagePadding: responsivePagePadding ?? this.responsivePagePadding,
      responsiveContentPadding: responsiveContentPadding ?? this.responsiveContentPadding,
      displayLarge: displayLarge ?? this.displayLarge,
      headingLarge: headingLarge ?? this.headingLarge,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      button: button ?? this.button,
    );
  }

  @override
  AppResponsiveThemeExtension lerp(covariant ThemeExtension<AppResponsiveThemeExtension>? other, double t) {
    if (other is! AppResponsiveThemeExtension) {
      return this;
    }
    // For functions, lerp doesn't make sense directly. We return the original or other based on t.
    // In a real scenario, you might have fixed values that can be lerped, or more complex logic.
    return AppResponsiveThemeExtension(
      responsivePagePadding: t < 0.5 ? responsivePagePadding : other.responsivePagePadding,
      responsiveContentPadding: t < 0.5 ? responsiveContentPadding : other.responsiveContentPadding,
      displayLarge: t < 0.5 ? displayLarge : other.displayLarge,
      headingLarge: t < 0.5 ? headingLarge : other.headingLarge,
      bodyLarge: t < 0.5 ? bodyLarge : other.bodyLarge,
      button: t < 0.5 ? button : other.button,
    );
  }

  // Helper to get the extension from context
  static AppResponsiveThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppResponsiveThemeExtension>()!;
  }
}

// Example usage in app_theme.dart (next step)
/*
ThemeData lightTheme = ThemeData(
  // ... existing theme properties
  extensions: <ThemeExtension<dynamic>>[
    AppResponsiveThemeExtension(
      responsivePagePadding: (context) => context.responsiveSpacing(AppSpacing.pagePadding),
      responsiveContentPadding: (context) => context.responsiveSpacing(AppSpacing.xl),
      displayLarge: (context) => AppTypography.displayLarge(context),
      headingLarge: (context) => AppTypography.headingLarge(context),
      bodyLarge: (context) => AppTypography.bodyLarge(context),
      button: (context) => AppTypography.button(context),
    ),
  ],
);
*/
