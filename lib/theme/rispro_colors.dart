import 'package:flutter/material.dart';

/// RISPRO Design System Color Tokens
/// Brand Character: Deep Forest + Teal + Amber + Mint Light Background
class RisproColors {
  // Brand Identity
  static const Color primary = Color(0xFF123B35); // Deep Forest
  static const Color primaryLight = Color(0xFF1B4E47);
  static const Color primaryDark = Color(0xFF0C2723);

  static const Color secondary = Color(0xFF147D69); // Teal
  static const Color secondaryLight = Color(0xFF1CA087);
  static const Color secondaryDark = Color(0xFF0F5E4F);

  static const Color accent = Color(0xFFF3A64A); // Warm Amber / CTA visual cue
  static const Color accentLight = Color(0xFFF7BD75);
  static const Color accentDark = Color(0xFFD68A2E);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF4FAF7); // Mint Crisp Light Background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Card Surface
  static const Color surfaceSubtle = Color(0xFFEAF5F1); // Soft Sage Surface
  static const Color surfaceMuted = Color(0xFFDFEDE8);

  // Typography Colors
  static const Color textMain = Color(0xFF18332E); // Deep Forest Charcoal
  static const Color textSecondary = Color(0xFF607570); // Muted Forest Slate
  static const Color textMuted = Color(0xFF8A9E99); // Soft Caption Slate
  static const Color textInverse = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFD5E8E1); // Soft Green Sage Border
  static const Color borderSubtle = Color(0xFFE6F2EE);
  static const Color borderFocused = Color(0xFF147D69);

  // Semantic Decision States
  static const Color certainty = Color(0xFF218C74); // Teal / Green for Certainty
  static const Color certaintyBg = Color(0xFFE5F7F2);

  static const Color risk = Color(0xFFE89B36); // Amber / Orange for Risk
  static const Color riskBg = Color(0xFFFDF3E5);

  static const Color uncertainty = Color(0xFF7C5CBF); // Soft Purple for Uncertainty
  static const Color uncertaintyBg = Color(0xFFF2EDFC);

  // Status Colors
  static const Color success = Color(0xFF218C74);
  static const Color successBg = Color(0xFFE6F6F2);
  static const Color warning = Color(0xFFE89B36);
  static const Color danger = Color(0xFFD95555);
  static const Color dangerBg = Color(0xFFFCE8E8);
  static const Color info = Color(0xFF2B7A8C);
  static const Color infoBg = Color(0xFFE8F4F7);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F322D), Color(0xFF166052)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7B05B), Color(0xFFE8932C)],
  );

  static const LinearGradient surfaceCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FDFC)],
  );

  // Soft Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.05),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: primary.withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get prominentShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get ctaShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}
