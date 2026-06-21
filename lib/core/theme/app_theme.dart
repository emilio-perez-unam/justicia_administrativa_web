import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

class AppTheme {
  static const Color brandColor = Color(0xFF1E3A8A); // Navy Blue
  static const Color accentColor = Color(0xFFD4AF37); // Gold

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      primary: brandColor,
      secondary: accentColor,
      surface: Colors.white,
      error: const Color(0xFFDC2626),
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: AppTypography.getMainTextTheme(
      ThemeData(useMaterial3: true).textTheme,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: brandColor,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: brandColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD6DFEC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD6DFEC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: brandColor, width: 1.2),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: const BorderSide(color: Color(0xFFD6DFEC)),
      backgroundColor: const Color(0xFFF8FAFC),
      labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    extensions: <ThemeExtension>[
      const AppThemeExtension(
        background: AppColors.backgroundLight,
        foreground: AppColors.foregroundLight,
        card: AppColors.cardLight,
        cardForeground: AppColors.cardForegroundLight,
        popover: AppColors.popoverLight,
        popoverForeground: AppColors.popoverForegroundLight,
        primary: AppColors.primaryLight,
        primaryForeground: AppColors.primaryForegroundLight,
        secondary: AppColors.secondaryLight,
        secondaryForeground: AppColors.secondaryForegroundLight,
        muted: AppColors.mutedLight,
        mutedForeground: AppColors.mutedForegroundLight,
        accent: AppColors.accentLight,
        accentForeground: AppColors.accentForegroundLight,
        destructive: AppColors.destructiveLight,
        destructiveForeground: AppColors.destructiveForegroundLight,
        border: AppColors.borderLight,
        input: AppColors.inputLight,
        inputBackground: AppColors.inputBackgroundLight,
        switchBackground: AppColors.switchBackgroundLight,
        ring: AppColors.ringLight,
        chart1: AppColors.chart1Light,
        chart2: AppColors.chart2Light,
        chart3: AppColors.chart3Light,
        chart4: AppColors.chart4Light,
        chart5: AppColors.chart5Light,
        sidebar: AppColors.sidebarLight,
        sidebarForeground: AppColors.sidebarForegroundLight,
        sidebarPrimary: AppColors.sidebarPrimaryLight,
        sidebarPrimaryForeground: AppColors.sidebarPrimaryForegroundLight,
        sidebarAccent: AppColors.sidebarAccentLight,
        sidebarAccentForeground: AppColors.sidebarAccentForegroundLight,
        sidebarBorder: AppColors.sidebarBorderLight,
        sidebarRing: AppColors.sidebarRingLight,
      ),
    ],
  );
}
