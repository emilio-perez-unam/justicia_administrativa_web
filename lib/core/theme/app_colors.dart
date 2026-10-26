import 'package:flutter/material.dart';

/// Raw color palette derived from the Figma/CSS variables.
///
/// We map the CSS `oklch` and hex values to Flutter `Color` objects.
/// Note: OKLCH values have been approximated to sRGB Hex for compatibility.
class AppColors {
  // Prevent instantiation
  const AppColors._();

  // --- Light Mode Palette ---
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF242424); // oklch(0.145 0 0)

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardForegroundLight = Color(0xFF242424);

  static const Color popoverLight = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color popoverForegroundLight = Color(0xFF242424);

  static const Color primaryLight = Color(0xFF030213);
  static const Color primaryForegroundLight = Color(0xFFFFFFFF);

  static const Color secondaryLight = Color(
    0xFFF3F4F6,
  ); // oklch(0.95 0.0058 264.53)
  static const Color secondaryForegroundLight = Color(0xFF030213);

  static const Color mutedLight = Color(0xFFECECF0);
  static const Color mutedForegroundLight = Color(0xFF717182);

  static const Color accentLight = Color(0xFFE9EBEF);
  static const Color accentForegroundLight = Color(0xFF030213);

  static const Color destructiveLight = Color(0xFFD4183D);
  static const Color destructiveForegroundLight = Color(0xFFFFFFFF);

  static const Color borderLight = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color inputLight = Colors.transparent;
  static const Color inputBackgroundLight = Color(0xFFF3F3F5);
  static const Color switchBackgroundLight = Color(0xFFCBCED4);

  static const Color ringLight = Color(0xFFB8B8B8); // oklch(0.708 0 0)

  // Charts Light
  static const Color chart1Light = Color(
    0xFFE76E50,
  ); // oklch(0.646 0.222 41.116)
  static const Color chart2Light = Color(
    0xFF2A9D8F,
  ); // oklch(0.6 0.118 184.704)
  static const Color chart3Light = Color(
    0xFF264653,
  ); // oklch(0.398 0.07 227.392)
  static const Color chart4Light = Color(
    0xFFF4A261,
  ); // oklch(0.828 0.189 84.429)
  static const Color chart5Light = Color(
    0xFFE9C46A,
  ); // oklch(0.769 0.188 70.08)

  // Sidebar Light
  static const Color sidebarLight = Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const Color sidebarForegroundLight = Color(
    0xFF242424,
  ); // oklch(0.145 0 0)
  static const Color sidebarPrimaryLight = Color(0xFF030213);
  static const Color sidebarPrimaryForegroundLight = Color(0xFFFBFBFB);
  static const Color sidebarAccentLight = Color(0xFFF7F7F7); // oklch(0.97 0 0)
  static const Color sidebarAccentForegroundLight = Color(
    0xFF333333,
  ); // oklch(0.205 0 0)
  static const Color sidebarBorderLight = Color(0xFFEBEBEB); // oklch(0.922 0 0)
  static const Color sidebarRingLight = Color(0xFFB8B8B8);

  // --- Dark Mode Palette ---
  static const Color backgroundDark = Color(0xFF242424); // oklch(0.145 0 0)
  static const Color foregroundDark = Color(0xFFFBFBFB); // oklch(0.985 0 0)

  static const Color cardDark = Color(0xFF242424);
  static const Color cardForegroundDark = Color(0xFFFBFBFB);

  static const Color popoverDark = Color(0xFF242424);
  static const Color popoverForegroundDark = Color(0xFFFBFBFB);

  static const Color primaryDark = Color(0xFFFBFBFB);
  static const Color primaryForegroundDark = Color(
    0xFF333333,
  ); // oklch(0.205 0 0)

  static const Color secondaryDark = Color(0xFF424242); // oklch(0.269 0 0)
  static const Color secondaryForegroundDark = Color(0xFFFBFBFB);

  static const Color mutedDark = Color(0xFF424242);
  static const Color mutedForegroundDark = Color(
    0xFFB8B8B8,
  ); // oklch(0.708 0 0)

  static const Color accentDark = Color(0xFF424242);
  static const Color accentForegroundDark = Color(0xFFFBFBFB);

  static const Color destructiveDark = Color(
    0xFF991B1B,
  ); // oklch(0.396 0.141 25.723)
  static const Color destructiveForegroundDark = Color(
    0xFFFFCCCC,
  ); // oklch(0.637 0.237 25.331)

  static const Color borderDark = Color(0xFF424242);
  static const Color inputDark = Color(0xFF424242);
  static const Color inputBackgroundDark = Color(
    0xFF424242,
  ); // Assuming same as input for dark mode fallback if not specified
  // Note: --switch-background not explicitly defined for dark in provided CSS, using muted
  static const Color switchBackgroundDark = Color(0xFF424242);

  static const Color ringDark = Color(0xFF707070); // oklch(0.439 0 0)

  // Charts Dark
  static const Color chart1Dark = Color(
    0xFF2662D9,
  ); // oklch(0.488 0.243 264.376)
  static const Color chart2Dark = Color(0xFF2EB886); // oklch(0.696 0.17 162.48)
  static const Color chart3Dark = Color(0xFFE9C46A); // oklch(0.769 0.188 70.08)
  static const Color chart4Dark = Color(0xFFE23670); // oklch(0.627 0.265 303.9)
  static const Color chart5Dark = Color(
    0xFFE76E50,
  ); // oklch(0.645 0.246 16.439)

  // Sidebar Dark
  static const Color sidebarDark = Color(0xFF333333); // oklch(0.205 0 0)
  static const Color sidebarForegroundDark = Color(0xFFFBFBFB);
  static const Color sidebarPrimaryDark = Color(0xFF2662D9);
  static const Color sidebarPrimaryForegroundDark = Color(0xFFFBFBFB);
  static const Color sidebarAccentDark = Color(0xFF424242);
  static const Color sidebarAccentForegroundDark = Color(0xFFFBFBFB);
  static const Color sidebarBorderDark = Color(0xFF424242);
  static const Color sidebarRingDark = Color(0xFF707070);

  // --- Brand & Semantic Tokens ---
  // Canonical brand colors; prefer these over raw hex in components.
  static const Color brandNavy = Color(0xFF1E3A8A);
  static const Color brandNavyDeep = Color(0xFF10203D);
  static const Color brandGold = Color(0xFFD4AF37);

  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);
  static const Color danger = Color(0xFFB91C1C);
  static const Color info = Color(0xFF1D4ED8);
}
