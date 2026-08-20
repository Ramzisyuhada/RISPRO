import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_card.dart';
import '../widgets/rispro_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final team = [
      {"name": "Steviani Batti', S.Kom., M.M", "role": "Peneliti Utama"},
      {"name": "Gunawan Wiradharma, S.Pd., S.I.Kom., M.Si., M.Hum.", "role": "Peneliti"},
      {"name": "Mario Aditya Prasetyo, S.Pd., S.I.Kom., M.I.Kom.", "role": "Peneliti"},
      {"name": "Zaenab Diah Febriani", "role": "Pengembang Aplikasi"},
      {"name": "Eriel Dantes", "role": "Pengembang Aplikasi"},
      {"name": "Galih Ashari R.", "role": "Pengembang Aplikasi"},
      {"name": "Ramzi Syuhada", "role": "Pengembang Aplikasi"},
    ];

    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Tentang RISPRO"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 36 : 20,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Hero Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [RisproColors.primaryDark, RisproColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: RisproColors.primary.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: RisproColors.accent.withValues(alpha: 0.25),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const RisproLogoIcon(size: 54),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "RISPRO",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    "Risk Decision Simulator - Sektor Publik",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade().slideY(begin: -0.1),

                      const SizedBox(height: 20),

                      // 2. Info Cards
                      _aboutInfoCard(
                        icon: Icons.psychology_rounded,
                        title: "Apa itu RISPRO?",
                        content:
                            "RISPRO adalah media pembelajaran interaktif berbasis simulasi pengambilan keputusan manajemen risiko proyek sektor publik. Pengguna dilatih menganalisis konsekuensi keputusan dalam kondisi Certainty, Risk, dan Uncertainty dengan umpan balik terstruktur.",
                        accentColor: RisproColors.secondary,
                      ).animate().fade(delay: 150.ms),

                      const SizedBox(height: 12),

                      _aboutInfoCard(
                        icon: Icons.track_changes_rounded,
                        title: "Tujuan Pembelajaran",
                        content:
                            "Mengembangkan intuisi strategis, pemahaman trade-off (biaya, waktu, risiko), serta kepatuhan tata kelola publik berbasis standar ISO 31000.",
                        accentColor: RisproColors.accentDark,
                      ).animate().fade(delay: 250.ms),

                      const SizedBox(height: 12),

                      _aboutInfoCard(
                        icon: Icons.schema_rounded,
                        title: "Mekanisme Simulasi",
                        content:
                            "Sistem menyajikan skenario keputusan proyek publik bertahap. Setiap pilihan memiliki dampak langsung terhadap indikator proyek serta profil preferensi risiko pengguna.",
                        accentColor: RisproColors.primary,
                      ).animate().fade(delay: 350.ms),

                      const SizedBox(height: 24),

                      // 3. Team Section
                      Text(
                        "Tim Peneliti & Pengembang",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: RisproColors.textMain,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: team.length,
                          itemBuilder: (context, index) {
                            final member = team[index];
                            final initial = member["name"]!.substring(0, 1);

                            return Container(
                              width: 170,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: RisproColors.border, width: 1),
                                boxShadow: RisproColors.cardShadow,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: RisproColors.primary.withValues(alpha: 0.1),
                                    child: Text(
                                      initial,
                                      style: GoogleFonts.poppins(
                                        color: RisproColors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member["name"]!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: RisproColors.textMain,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    member["role"]!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: RisproColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ).animate().fade(delay: 450.ms),

                      const SizedBox(height: 28),

                      // CTA
                      RisproButton(
                        text: "Mulai Simulasi Proyek",
                        icon: Icons.play_arrow_rounded,
                        isTrailingIcon: true,
                        variant: RisproButtonVariant.primaryCta,
                        onPressed: () => Navigator.pushNamed(context, '/game'),
                      ).animate().fade(delay: 550.ms),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _aboutInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return RisproCard(
      accentColor: accentColor,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: RisproColors.textMain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: RisproColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}