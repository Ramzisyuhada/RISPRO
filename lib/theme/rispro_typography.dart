import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rispro_colors.dart';

/// RISPRO Centralized Typography System based on Poppins
class RisproTypography {
  static TextStyle get displayHeroTablet => GoogleFonts.poppins(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: RisproColors.textMain,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get displayHeroMobile => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: RisproColors.textMain,
    height: 1.25,
    letterSpacing: -0.4,
  );

  static TextStyle get pageTitle => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: RisproColors.textMain,
    height: 1.3,
  );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: RisproColors.textMain,
    height: 1.35,
  );

  static TextStyle get cardTitle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: RisproColors.textMain,
    height: 1.4,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: RisproColors.textMain,
    height: 1.5,
  );

  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: RisproColors.textMain,
    height: 1.55,
  );

  static TextStyle get bodySecondary => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: RisproColors.textSecondary,
    height: 1.55,
  );

  static TextStyle get buttonLarge => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.1,
    height: 1.2,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: RisproColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get badgeText => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 1.2,
  );
}
