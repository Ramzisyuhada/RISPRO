import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_card.dart';
import '../widgets/rispro_logo.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RisproColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isSmallMobile = width < 420;
            final isTablet = width >= 700;
            final isWide = width >= 960;

            final horizontalPadding = isWide
                ? 48.0
                : (isTablet
                    ? 32.0
                    : (isSmallMobile ? 12.0 : 18.0));
            final verticalPadding = isTablet ? 24.0 : 14.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: isTablet
                      ? _TabletLayout(
                          onStart: () => Navigator.pushNamed(context, '/game'),
                          isWide: isWide,
                        )
                      : _MobileLayout(
                          onStart: () => Navigator.pushNamed(context, '/game'),
                          isSmallMobile: isSmallMobile,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final VoidCallback onStart;
  final bool isSmallMobile;

  const _MobileLayout({
    required this.onStart,
    required this.isSmallMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header with Prominent RISPRO Brand Lockup
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 10 : 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: RisproColors.border, width: 1),
            boxShadow: RisproColors.cardShadow,
          ),
          child: Row(
            children: [
              // Brand Logo Lockup
              Expanded(
                child: RisproLogoLockup(
                  iconSize: isSmallMobile ? 28 : 34,
                  showSubtitle: !isSmallMobile,
                  subtitleText: "Risk Decision Simulator",
                ),
              ),
              const SizedBox(width: 6),

              // Interactive Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: RisproColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RisproColors.border, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: RisproColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Interaktif",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: RisproColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fade(duration: 400.ms).slideY(begin: -0.15),

        const SizedBox(height: 16),

        // 2. Hero Launchpad Card with Logo Accent & Lottie
        Container(
          padding: EdgeInsets.all(isSmallMobile ? 16 : 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F3630), Color(0xFF165448)],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: RisproColors.primary.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: RisproColors.accent.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Badge with mini logo emblem
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: RisproColors.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: RisproColors.accent.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 13,
                          color: RisproColors.accentLight,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "SIMULASI RISIKO SEKTOR PUBLIK",
                          style: GoogleFonts.poppins(
                            fontSize: isSmallMobile ? 9.5 : 10.5,
                            fontWeight: FontWeight.w800,
                            color: RisproColors.accentLight,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                "Risk Decision Simulator",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isSmallMobile ? 22 : 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Latih pengambilan keputusan manajemen risiko proyek sektor publik dalam kondisi Certainty, Risk, & Uncertainty.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isSmallMobile ? 12.5 : 13.5,
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 14),

              // Simulation Visual Graphic / Robot
              SizedBox(
                height: isSmallMobile ? 120 : 140,
                child: Lottie.asset(
                  'assets/AssetGame/Robots.json',
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.psychology_rounded,
                    size: 70,
                    color: RisproColors.accent,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Prominent CTA Button
              RisproButton(
                text: "Mulai Simulasi",
                icon: Icons.play_arrow_rounded,
                isTrailingIcon: true,
                fontSize: 17,
                height: 56,
                width: double.infinity,
                variant: RisproButtonVariant.accent,
                onPressed: onStart,
              ),
            ],
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.15),

        const SizedBox(height: 20),

        // 3. Section Title
        Text(
          "Menu Utama Pembelajaran",
          style: GoogleFonts.poppins(
            fontSize: isSmallMobile ? 15 : 17,
            fontWeight: FontWeight.w700,
            color: RisproColors.textMain,
          ),
        ).animate().fade(delay: 350.ms),

        const SizedBox(height: 10),

        // 4. Feature Cards
        RisproFeatureCard(
          icon: Icons.auto_stories_rounded,
          title: "Materi Pembelajaran",
          description: "Pelajari konsep manajemen risiko publik lewat slide PPT dan video interaktif.",
          tag: "Slide & Video",
          accentColor: RisproColors.secondary,
          onTap: () => Navigator.pushNamed(context, '/materi'),
        ).animate().fade(delay: 450.ms).slideX(begin: -0.1),

        const SizedBox(height: 10),

        RisproFeatureCard(
          icon: Icons.quiz_rounded,
          title: "Uji Pemahaman (Kuis)",
          description: "Evaluasi penguasaan teori risiko melalui 30 butir studi kasus terstruktur.",
          tag: "30 Soal",
          accentColor: RisproColors.accentDark,
          onTap: () => Navigator.pushNamed(context, '/quiz'),
        ).animate().fade(delay: 550.ms).slideX(begin: 0.1),

        const SizedBox(height: 10),

        RisproFeatureCard(
          icon: Icons.info_outline_rounded,
          title: "Tentang RISPRO",
          description: "Informasi media pembelajaran, metodologi simulasi, dan tim riset pengembang.",
          tag: "Riset",
          accentColor: RisproColors.primary,
          onTap: () => Navigator.pushNamed(context, '/about'),
        ).animate().fade(delay: 650.ms).slideX(begin: -0.1),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final VoidCallback onStart;
  final bool isWide;

  const _TabletLayout({
    required this.onStart,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header Bar with Logo Lockup
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: RisproColors.border, width: 1.2),
            boxShadow: RisproColors.cardShadow,
          ),
          child: Row(
            children: [
              const Expanded(
                child: RisproLogoLockup(
                  iconSize: 40,
                  showSubtitle: true,
                  subtitleText: "Risk Decision Simulator",
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: RisproColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RisproColors.border, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: RisproColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Media Pembelajaran Interaktif",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: RisproColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fade(duration: 400.ms).slideY(begin: -0.15),

        const SizedBox(height: 24),

        // 2. Tablet Hero Card with Asymmetric Layout
        Container(
          padding: EdgeInsets.all(isWide ? 36 : 28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F3630), Color(0xFF165448)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: RisproColors.primary.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(
              color: RisproColors.accent.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: RisproColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: RisproColors.accent.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "SIMULASI KEPUTUSAN PROYEK SEKTOR PUBLIK",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: RisproColors.accentLight,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Risk Decision Simulator",
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 36 : 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Anda berperan sebagai Project Manager proyek digital sektor publik. Setiap keputusan diambil dalam kondisi certainty, risk, dan uncertainty dengan konsekuensi nyata.",
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 16 : 14.5,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: 280,
                      child: RisproButton(
                        text: "Mulai Simulasi",
                        icon: Icons.play_arrow_rounded,
                        isTrailingIcon: true,
                        fontSize: 17,
                        height: 56,
                        variant: RisproButtonVariant.accent,
                        onPressed: onStart,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: isWide ? 280 : 230,
                  child: Lottie.asset(
                    'assets/AssetGame/Robots.json',
                    repeat: true,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.psychology_rounded,
                      size: 120,
                      color: RisproColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.15),

        const SizedBox(height: 28),

        // 3. Responsive Feature Grid for Tablet / Wide
        Text(
          "Menu Utama Pembelajaran",
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: RisproColors.textMain,
          ),
        ).animate().fade(delay: 350.ms),

        const SizedBox(height: 14),

        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RisproFeatureCard(
                  icon: Icons.auto_stories_rounded,
                  title: "Materi Pembelajaran",
                  description: "Slide PPT & video interaktif manajemen risiko publik.",
                  tag: "Slide & Video",
                  accentColor: RisproColors.secondary,
                  onTap: () => Navigator.pushNamed(context, '/materi'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: RisproFeatureCard(
                  icon: Icons.quiz_rounded,
                  title: "Uji Pemahaman",
                  description: "30 butir soal evaluasi pemahaman terstruktur.",
                  tag: "30 Soal",
                  accentColor: RisproColors.accentDark,
                  onTap: () => Navigator.pushNamed(context, '/quiz'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: RisproFeatureCard(
                  icon: Icons.info_outline_rounded,
                  title: "Tentang RISPRO",
                  description: "Metodologi simulasi dan tim riset pengembang.",
                  tag: "Riset",
                  accentColor: RisproColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
              ),
            ],
          ).animate().fade(delay: 500.ms).slideY(begin: 0.1)
        else
          Column(
            children: [
              RisproFeatureCard(
                icon: Icons.auto_stories_rounded,
                title: "Materi Pembelajaran",
                description: "Slide PPT & video interaktif manajemen risiko publik.",
                tag: "Slide & Video",
                accentColor: RisproColors.secondary,
                onTap: () => Navigator.pushNamed(context, '/materi'),
              ),
              const SizedBox(height: 10),
              RisproFeatureCard(
                icon: Icons.quiz_rounded,
                title: "Uji Pemahaman (Kuis)",
                description: "30 butir soal evaluasi pemahaman terstruktur.",
                tag: "30 Soal",
                accentColor: RisproColors.accentDark,
                onTap: () => Navigator.pushNamed(context, '/quiz'),
              ),
              const SizedBox(height: 10),
              RisproFeatureCard(
                icon: Icons.info_outline_rounded,
                title: "Tentang RISPRO",
                description: "Metodologi simulasi dan tim riset pengembang.",
                tag: "Riset",
                accentColor: RisproColors.primary,
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ],
          ).animate().fade(delay: 500.ms).slideY(begin: 0.1),

        const SizedBox(height: 20),
      ],
    );
  }
}