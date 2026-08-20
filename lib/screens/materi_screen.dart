import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_card.dart';
import 'ppt_screen.dart';
import 'video_screen.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Materi Pembelajaran"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Editorial Introduction Card
                  RisproCard(
                    backgroundColor: Colors.white,
                    accentColor: RisproColors.secondary,
                    showAccentBar: true,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: RisproColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: RisproColors.secondary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Modul Manajemen Risiko Proyek Publik",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: RisproColors.textMain,
                                    ),
                                  ),
                                  Text(
                                    "Fondasi Pengambilan Keputusan Strategis",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: RisproColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Manajemen risiko sektor publik membantu pengelola proyek mengidentifikasi, mengukur, dan merespons ketidakpastian secara sistematis pada 3 kondisi utama: Certainty (Pasti), Risk (Terukur), dan Uncertainty (Tidak Pasti).",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: RisproColors.textMain,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(begin: -0.1),

                  const SizedBox(height: 24),

                  // 2. Section: Format Pembelajaran
                  Text(
                    "Pilih Format Media",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: RisproColors.textMain,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Dual Media Cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;

                      final pptCard = _MediaCard(
                        icon: Icons.slideshow_rounded,
                        title: "Slide Presentasi (PPT)",
                        subtitle: "21 Slide Terstruktur",
                        description: "Materi visual komprehensif konsep risiko, tahapan ISO 31000, dan studi kasus proyek publik.",
                        accentColor: RisproColors.secondary,
                        buttonLabel: "Buka Slide PPT",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PptScreen()),
                        ),
                      );

                      final videoCard = _MediaCard(
                        icon: Icons.play_circle_outline_rounded,
                        title: "Video Penjelasan",
                        subtitle: "Video Pembelajaran Interaktif",
                        description: "Penjelasan mendalam mekanisme evaluasi dan simulasi keputusan risiko proyek sektor publik.",
                        accentColor: RisproColors.accentDark,
                        buttonLabel: "Tonton Video",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VideoScreen()),
                        ),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: pptCard),
                            const SizedBox(width: 16),
                            Expanded(child: videoCard),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          pptCard,
                          const SizedBox(height: 14),
                          videoCard,
                        ],
                      );
                    },
                  ).animate().fade(delay: 200.ms),

                  const SizedBox(height: 28),

                  // 4. Highlighted Takeaways
                  Text(
                    "3 Pilar Keputusan Risiko",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: RisproColors.textMain,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _PillarCard(
                    title: "Certainty (Kondisi Pasti)",
                    description: "Informasi tersedia lengkap. Fokus pada efisiensi biaya dan optimasi jadwal kerja.",
                    color: RisproColors.certainty,
                    icon: Icons.verified_user_rounded,
                  ).animate().fade(delay: 300.ms).slideX(begin: -0.1),

                  const SizedBox(height: 10),

                  _PillarCard(
                    title: "Risk (Kondisi Berisiko)",
                    description: "Probabilitas dan dampak dapat diestimasi. Fokus pada trade-off antara mitigasi vs alokasi sumber daya.",
                    color: RisproColors.risk,
                    icon: Icons.warning_amber_rounded,
                  ).animate().fade(delay: 400.ms).slideX(begin: 0.1),

                  const SizedBox(height: 10),

                  _PillarCard(
                    title: "Uncertainty (Ketidakpastian)",
                    description: "Informasi terbatas dan tidak dapat diprediksi. Fokus pada strategi adaptif dan fleksibilitas penanganan.",
                    color: RisproColors.uncertainty,
                    icon: Icons.help_outline_rounded,
                  ).animate().fade(delay: 500.ms).slideX(begin: -0.1),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final String buttonLabel;
  final VoidCallback onTap;

  const _MediaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RisproCard(
      onTap: onTap,
      accentColor: accentColor,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 26, color: accentColor),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: RisproColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                buttonLabel,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const _PillarCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RisproColors.border, width: 1),
        boxShadow: RisproColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: RisproColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: RisproColors.textSecondary,
                    height: 1.45,
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