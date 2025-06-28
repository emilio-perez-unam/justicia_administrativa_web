import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';

/// Typography system for Justicia Administrativa
/// Uses IBM Plex for body text and Cormorant Garamond for headings
class AppTypography {
  // Display Styles (for hero sections)
  static TextStyle displayLarge = GoogleFonts.cormorantGaramond(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.cormorantGaramond(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Heading Styles
  static TextStyle headingLarge = GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingMedium = GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle headingSmall = GoogleFonts.ibmPlexSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.ibmPlexSans(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.ibmPlexSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.ibmPlexSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Special Styles
  static TextStyle button = GoogleFonts.ibmPlexSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1,
    letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.ibmPlexSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.5,
  );

  static TextStyle navItem = GoogleFonts.ibmPlexSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryNavy,
    height: 1,
  );
}
