import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/service/simulation_ai_service.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_card.dart';
import '../widgets/rispro_progress_journey.dart';

class Scene7Screen extends StatefulWidget {
  final Map total;

  const Scene7Screen({super.key, required this.total});

  @override
  State<Scene7Screen> createState() => _Scene7ScreenState();
}

class _Scene7ScreenState extends State<Scene7Screen> {
  final aiService = SimulationAIService();

  Map<String, dynamic>? result;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAI();
  }

  void loadAI() async {
    try {
      final res = await aiService.generateFinalAnalysisScane7(widget.total);
      if (!mounted) return;
      setState(() {
        result = normalizeResult(Map<String, dynamic>.from(res));
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        result = normalizeResult(null);
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> normalizeResult(Map<String, dynamic>? raw) {
    final data = raw ?? {};

    final score = data["score"] is Map
        ? Map<String, dynamic>.from(data["score"])
        : {};

    return {
      "profile": data["profile"] ?? "Risk Neutral",
      "score": {
        "avoidance": score["avoidance"] ?? 33,
        "balance": score["balance"] ?? 34,
        "aggressive": score["aggressive"] ?? 33,
      },
      "riskLevel": data["riskLevel"] ?? "medium",
      "efficiency": data["efficiency"] ?? "medium",
      "publicScore": data["publicScore"] ?? 50,
      "analysis": data["analysis"] ?? "Analisis pola keputusan menunjukkan pendekatan seimbang dalam merespons risiko.",
      "impactSummary": data["impactSummary"] ?? "Keputusan diambil dengan mempertimbangkan konsekuensi proyek.",
      "recommendation": data["recommendation"] ?? "Pertahankan evaluasi berbasis data sebelum mengambil tindakan berisiko tinggi.",
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: RisproColors.background,
        appBar: RisproAppBar(title: "Analisis Profil Risiko", showBack: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: RisproColors.secondary),
              SizedBox(height: 16),
              Text("Menganalisis pola keputusan Anda..."),
            ],
          ),
        ),
      );
    }

    final profile = result!["profile"] as String;
    final score = result!["score"] as Map;

    final avoidance = ((score["avoidance"] as num?)?.toDouble() ?? 33) / 100;
    final balance = ((score["balance"] as num?)?.toDouble() ?? 34) / 100;
    final aggressive = ((score["aggressive"] as num?)?.toDouble() ?? 33) / 100;

    final analysis = result!["analysis"] as String;
    final summary = result!["impactSummary"] as String;
    final recommendation = result!["recommendation"] as String;

    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Analisis Profil Risiko", showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Progress Journey Header
                  const RisproProgressJourney(
                    currentStep: 5,
                    totalSteps: 5,
                    stageName: "Evaluasi & Profil Risiko",
                    subtitle: "Pemetaan gaya pengambilan keputusan Anda",
                  ),

                  const SizedBox(height: 16),

                  // 2. Dominant Profile Banner Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF103832), Color(0xFF165A4E)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: RisproColors.accent.withValues(alpha: 0.3), width: 1.2),
                      boxShadow: RisproColors.prominentShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: RisproColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "PROFIL KEPUTUSAN UTAMA",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: RisproColors.accentLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          profile,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Berdasarkan pilihan pada Certainty, Risk, & Uncertainty",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(begin: -0.1),

                  const SizedBox(height: 18),

                  // 3. 3 Risk Spectrum Cards
                  _riskSpectrumCard(
                    title: "Risk Averse (Konservatif)",
                    subtitle: "Cenderung memprioritaskan mitigasi aman & kepatuhan",
                    percent: avoidance,
                    color: RisproColors.certainty,
                    icon: Icons.shield_rounded,
                    isDominant: profile == "Risk Averse",
                  ),

                  _riskSpectrumCard(
                    title: "Risk Neutral (Seimbang)",
                    subtitle: "Menyeimbangkan efisiensi biaya vs proteksi risiko",
                    percent: balance,
                    color: RisproColors.risk,
                    icon: Icons.balance_rounded,
                    isDominant: profile == "Risk Neutral",
                  ),

                  _riskSpectrumCard(
                    title: "Risk Seeker (Agresif)",
                    subtitle: "Berani mengambil risiko tinggi demi efisiensi & kecepatan",
                    percent: aggressive,
                    color: RisproColors.danger,
                    icon: Icons.bolt_rounded,
                    isDominant: profile == "Risk Seeker",
                  ),

                  const SizedBox(height: 16),

                  // 4. Decision Pattern Analysis
                  RisproCard(
                    accentColor: RisproColors.secondary,
                    showAccentBar: true,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.analytics_rounded, color: RisproColors.secondary, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              "Analisis Pola Keputusan",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: RisproColors.textMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          analysis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: RisproColors.textMain,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms),

                  const SizedBox(height: 12),

                  // 5. Recommendation & Conclusion Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: RisproColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "💡 Kesimpulan & Rekomendasi",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: RisproColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          summary,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: RisproColors.textMain,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Rekomendasi: $recommendation",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: RisproColors.secondaryDark,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 300.ms),

                  const SizedBox(height: 24),

                  // 6. Action Button
                  RisproButton(
                    text: "Lihat Skor & Evaluasi Akhir →",
                    variant: RisproButtonVariant.primaryCta,
                    height: 56,
                    fontSize: 16,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/scene6',
                        (route) => false,
                        arguments: {
                          "total": {
                            "cost": aiService.totalImpact["cost"] ?? 0,
                            "time": aiService.totalImpact["time"] ?? 0,
                            "risk": aiService.totalImpact["risk"] ?? 0,
                          },
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _riskSpectrumCard({
    required String title,
    required String subtitle,
    required double percent,
    required Color color,
    required IconData icon,
    required bool isDominant,
  }) {
    final displayPercent = (percent * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDominant ? color.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDominant ? color : RisproColors.border,
          width: isDominant ? 2.0 : 1.0,
        ),
        boxShadow: isDominant
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : RisproColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: isDominant ? FontWeight.w800 : FontWeight.w700,
                    fontSize: 14,
                    color: isDominant ? color : RisproColors.textMain,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$displayPercent%",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: RisproColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              minHeight: 8,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}