import 'package:flutter/material.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/theme/app_responsive_theme_extension.dart'; // New import
import 'package:justicia_administrativa_web/core/utils/responsive_utils.dart'; // New import

/// Main theme configuration for Justicia Administrativa
class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryNavy,
        secondary: AppColors.accentGold,
        tertiary: AppColors.techBlue,
        surface: AppColors.surface,
        surfaceContainerHighest:
            AppColors.background, 
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      // Background colors
      scaffoldBackgroundColor: AppColors.background,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headingMedium(context),
        iconTheme: const IconThemeData(color: AppColors.primaryNavy),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge(context),
        displayMedium: AppTypography.displayMedium(context),
        headlineLarge: AppTypography.headingLarge(context),
        headlineMedium: AppTypography.headingMedium(context),
        headlineSmall: AppTypography.headingSmall(context),
        bodyLarge: AppTypography.bodyLarge(context),
        bodyMedium: AppTypography.bodyMedium(context),
        bodySmall: AppTypography.bodySmall(context),
        labelLarge: AppTypography.button(context),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTypography.button(context),
          elevation: 0,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.techBlue,
          textStyle: AppTypography.button(context),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.techBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),

      // Card theme - Fixed: Changed from CardTheme to CardThemeData
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          side: const BorderSide(color: AppColors.divider),
        ),
        margin: EdgeInsets.zero,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.lg,
      ),
      // Add AppResponsiveThemeExtension
      extensions: <ThemeExtension<dynamic>>[
        AppResponsiveThemeExtension(
          responsivePagePadding: (ctx) => ctx.responsiveSpacing(AppSpacing.pagePadding),
          responsiveContentPadding: (ctx) => ctx.responsiveSpacing(AppSpacing.xl),
          displayLarge: (ctx) => AppTypography.displayLarge(ctx),
          headingLarge: (ctx) => AppTypography.headingLarge(ctx),
          bodyLarge: (ctx) => AppTypography.bodyLarge(ctx),
          button: (ctx) => AppTypography.button(ctx),
        ),
      ],
    );
  }
}
