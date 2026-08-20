import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_card.dart';

class Scene8Screen extends StatelessWidget {
  const Scene8Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Refleksi Pembelajaran"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Banner
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF103630), Color(0xFF17574B)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: RisproColors.accent.withValues(alpha: 0.3), width: 1.2),
                      boxShadow: RisproColors.prominentShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Refleksi Evaluasi Pengambilan Keputusan",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Pembelajaran berbasis simulasi memungkinkan Anda mengalami langsung trade-off dan konsekuensi nyata dari setiap pilihan, bukan sekadar membaca teori.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(begin: -0.1),

                  const SizedBox(height: 20),

                  // 2. Reflection Pillars
                  Text(
                    "Poin Kunci Pembelajaran",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: RisproColors.textMain,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _reflectionPoint(
                    icon: Icons.paid_rounded,
                    title: "1. Akuntabilitas & Efisiensi Anggaran",
                    description: "Setiap kenaikan anggaran harus dijustifikasi dengan mitigasi risiko yang sebanding dan akuntabel kepada publik.",
                    color: RisproColors.primary,
                  ).animate().fade(delay: 150.ms).slideX(begin: -0.1),

                  const SizedBox(height: 10),

                  _reflectionPoint(
                    icon: Icons.tune_rounded,
                    title: "2. Efektivitas Respons Mitigasi",
                    description: "Mengidentifikasi risiko sejak awal (Certainty) jauh lebih hemat daripada menanggulangi krisis di tahap akhir (Uncertainty).",
                    color: RisproColors.secondary,
                  ).animate().fade(delay: 250.ms).slideX(begin: 0.1),

                  const SizedBox(height: 10),

                  _reflectionPoint(
                    icon: Icons.shield_rounded,
                    title: "3. Ketahanan Strategis Proyek",
                    description: "Kondisi tidak pasti memerlukan fleksibilitas rencana kerja dan cadangan kontinjensi yang memadai.",
                    color: RisproColors.accentDark,
                  ).animate().fade(delay: 350.ms).slideX(begin: -0.1),

                  const SizedBox(height: 24),

                  // 3. Dual Action Buttons
                  RisproButton(
                    text: "Ulangi Simulasi dengan Skenario Baru",
                    icon: Icons.replay_rounded,
                    variant: RisproButtonVariant.primaryCta,
                    height: 56,
                    fontSize: 16,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/game',
                        (route) => false,
                      );
                    },
                  ).animate().fade(delay: 450.ms),

                  const SizedBox(height: 12),

                  RisproButton(
                    text: "Kembali ke Menu Utama",
                    icon: Icons.home_rounded,
                    variant: RisproButtonVariant.secondary,
                    height: 54,
                    fontSize: 16,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ).animate().fade(delay: 550.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reflectionPoint({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return RisproCard(
      accentColor: color,
      padding: const EdgeInsets.all(18),
      borderRadius: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: RisproColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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