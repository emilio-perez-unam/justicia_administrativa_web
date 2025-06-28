import 'package:flutter/material.dart';

/// Color palette for Justicia Administrativa
/// Based on the brand guidelines: formal legal + modern tech
class AppColors {
  // Primary Colors
  static const Color primaryNavy = Color(0xFF1A2942); // Institutional navy
  static const Color accentGold = Color(0xFFD4AF37); // Premium gold accent
  static const Color techBlue = Color(0xFF0052CC); // Modern tech blue

  // Text Colors
  static const Color textPrimary = Color(
    0xFF0A0A0A,
  ); // Near black for main text
  static const Color textSecondary = Color(0xFF4A4A4A); // For subtitles
  static const Color textTertiary = Color(0xFF7A7A7A); // For metadata

  // Background Colors
  static const Color background = Color(0xFFFAFAFA); // Warm white background
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards
  static const Color divider = Color(0xFFE5E7EB); // Subtle borders

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // For success states
  static const Color error = Color(0xFFEF4444); // For error states
  static const Color warning = Color(0xFFF59E0B); // For warnings

  // Hover/Interaction States
  static const Color navyHover = Color(0xFF243347); // Darker navy for hover
  static const Color goldHover = Color(0xFFB8941F); // Darker gold for hover
}
