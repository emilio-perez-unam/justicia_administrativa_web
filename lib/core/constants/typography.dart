import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/utils/responsive_utils.dart'; // Import the new utility

/// Typography system for Justicia Administrativa
/// Uses IBM Plex for body text and Cormorant Garamond for headings
class AppTypography {
  // Display Styles (for hero sections)
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.cormorantGaramond(
        fontSize: context.responsiveFontSize(48), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.cormorantGaramond(
        fontSize: context.responsiveFontSize(36), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // Heading Styles
  static TextStyle headingLarge(BuildContext context) => GoogleFonts.cormorantGaramond(
        fontSize: context.responsiveFontSize(32), // Apply responsive scaling
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headingMedium(BuildContext context) => GoogleFonts.cormorantGaramond(
        fontSize: context.responsiveFontSize(24), // Apply responsive scaling
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle headingSmall(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(20), // Apply responsive scaling
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // Body Styles
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(18), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(16), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(14), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // Special Styles
  static TextStyle button(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(16), // Apply responsive scaling
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1,
        letterSpacing: 0.5,
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(12), // Apply responsive scaling
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.5,
      );

  static TextStyle navItem(BuildContext context) => GoogleFonts.ibmPlexSans(
        fontSize: context.responsiveFontSize(16), // Apply responsive scaling
        fontWeight: FontWeight.w500,
        color: AppColors.primaryNavy,
        height: 1,
      );
}
