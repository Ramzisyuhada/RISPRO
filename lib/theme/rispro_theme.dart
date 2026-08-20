import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rispro_colors.dart';

class RisproTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: RisproColors.primary,
      scaffoldBackgroundColor: RisproColors.background,
      canvasColor: RisproColors.background,
      cardColor: RisproColors.surface,
      dividerColor: RisproColors.border,
      
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: RisproColors.primary,
        onPrimary: Colors.white,
        secondary: RisproColors.secondary,
        onSecondary: Colors.white,
        tertiary: RisproColors.accent,
        onTertiary: Colors.white,
        error: RisproColors.danger,
        onError: Colors.white,
        surface: RisproColors.surface,
        onSurface: RisproColors.textMain,
      ),

      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: RisproColors.textMain,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: RisproColors.textMain,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: RisproColors.textMain,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: RisproColors.textMain,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: RisproColors.textMain,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: RisproColors.textMain,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: RisproColors.textSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: RisproColors.background,
        foregroundColor: RisproColors.textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: RisproColors.primary, size: 24),
      ),

      cardTheme: CardThemeData(
        color: RisproColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: RisproColors.border, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RisproColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RisproColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: RisproColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: RisproColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: RisproColors.secondary, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(
          color: RisproColors.textSecondary,
          fontSize: 15,
        ),
        hintStyle: GoogleFonts.poppins(
          color: RisproColors.textMuted,
          fontSize: 15,
        ),
      ),
    );
  }
}
