import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme getMainTextTheme(TextTheme base) {
    // Use Inter as the base for body text
    final baseTheme = GoogleFonts.interTextTheme(base);

    return baseTheme.copyWith(
      // Display styles (Hero titles, large headers) -> Playfair Display
      displayLarge: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.displayLarge,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.displayMedium,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.displaySmall,
        fontWeight: FontWeight.w700,
      ),

      // Headlines (Section titles) -> Playfair Display
      headlineLarge: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.headlineLarge,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.headlineMedium,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.headlineSmall,
        fontWeight: FontWeight.w700,
      ),

      // Titles -> Playfair Display (optional, can be Inter for smaller titles)
      titleLarge: GoogleFonts.playfairDisplay(
        textStyle: baseTheme.titleLarge,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: baseTheme.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        textStyle: baseTheme.titleSmall,
        fontWeight: FontWeight.w600,
      ),

      // Body -> Inter
      bodyLarge: GoogleFonts.inter(
        textStyle: baseTheme.bodyLarge,
        height: 1.6, // Relaxed line height for readability
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: baseTheme.bodyMedium,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(textStyle: baseTheme.bodySmall),

      // Labels (Buttons, tags) -> Inter
      labelLarge: GoogleFonts.inter(
        textStyle: baseTheme.labelLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
