import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../domain/service/simulation_ai_service.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_card.dart';

class Scene6Screen extends StatefulWidget {
  final Map total;

  const Scene6Screen({super.key, required this.total});

  @override
  State<Scene6Screen> createState() => _Scene6ScreenState();
}

class _Scene6ScreenState extends State<Scene6Screen> {
  final aiService = SimulationAIService();

  Map<String, dynamic>? analysis;
  bool isLoading = true;
  int animatedScore = 0;

  @override
  void initState() {
    super.initState();
    loadAnalysis();
  }

  int clamp(int value) => value.clamp(0, 100);

  int calculateScore(Map total) {
    final total1 = aiService.getTotalImpact();

    int cost = clamp(total1["cost"] ?? 0);
    int time = clamp(total1["time"] ?? 0);
    int risk = clamp(total1["risk"] ?? 0);

    int score = 100;
    score -= (cost * 0.3).toInt();
    score -= (time * 0.3).toInt();
    score -= (risk * 0.4).toInt();

    return clamp(score);
  }

  void loadAnalysis() async {
    try {
      final res = await aiService.generateFinalAnalysis(widget.total);
      final localScore = calculateScore(widget.total);

      if (!mounted) return;
      setState(() {
        analysis = Map<String, dynamic>.from(res);
        analysis!["publicScore"] = localScore;
        isLoading = false;
      });

      startScoreAnimation(localScore);
    } catch (_) {
      final fallback = calculateScore(widget.total);

      if (!mounted) return;
      setState(() {
        analysis = {
          "publicScore": fallback,
          "summary": "Analisis dampak keputusan menunjukkan mitigasi terukur pada proyek sektor publik.",
          "mitigation": "Mitigasi berjalan dengan penyesuaian anggaran dan waktu.",
          "recommendation": "Tingkatkan ketahanan sistem pada fase ketidakpastian tinggi.",
          "learningInsight": "Setiap keputusan dalam proyek publik memiliki konsekuensi langsung pada akuntabilitas anggaran dan manfaat sosial.",
        };
        isLoading = false;
      });

      startScoreAnimation(fallback);
    }
  }

  void startScoreAnimation(int finalScore) async {
    for (int i = 0; i <= finalScore; i++) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) return;
      setState(() => animatedScore = i);
    }
  }

  Color getScoreColor(int score) {
    if (score < 40) return RisproColors.danger;
    if (score < 70) return RisproColors.warning;
    return RisproColors.success;
  }

  String getRankLabel(int score) {
    if (score < 40) return "Perlu Evaluasi Mendalam";
    if (score < 70) return "Kinerja Cukup Baik";
    return "Sangat Baik (Strategic Master)";
  }

  String getCharacterImage(int score) {
    if (score < 40) return "assets/AssetGame/player_woried.png";
    if (score < 70) return "assets/AssetGame/player_thinking.png";
    return "assets/AssetGame/player_confident.png";
  }

  @override
  Widget build(BuildContext context) {
    final total = aiService.getTotalImpact();

    final cost = clamp(total["cost"] ?? 0);
    final time = clamp(total["time"] ?? 0);
    final risk = clamp(total["risk"] ?? 0);

    final score = clamp(analysis?["publicScore"] ?? 0);
    final scoreColor = getScoreColor(score);

    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Hasil & Evaluasi Keputusan", showBack: false),
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
                  // 1. Hero Score Card
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF103630), Color(0xFF17574B)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: RisproColors.accent.withValues(alpha: 0.35), width: 1.5),
                      boxShadow: RisproColors.prominentShadow,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white.withValues(alpha: 0.12),
                          child: Image.asset(
                            getCharacterImage(score),
                            key: ValueKey(score),
                            height: 68,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "SKOR KINERJA MANAJEMEN RISIKO",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: RisproColors.accentLight,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$animatedScore / 100",
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: scoreColor.withValues(alpha: 0.6), width: 1),
                          ),
                          child: Text(
                            getRankLabel(score),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(),

                  const SizedBox(height: 16),

                  // 2. Impact Metrics Cards (Cost, Time, Risk)
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          title: "Biaya (Cost)",
                          value: "$cost%",
                          color: Colors.red.shade700,
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _metricCard(
                          title: "Waktu (Time)",
                          value: "$time%",
                          color: Colors.orange.shade800,
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _metricCard(
                          title: "Risiko (Risk)",
                          value: "$risk%",
                          color: RisproColors.primary,
                          icon: Icons.shield_outlined,
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 200.ms),

                  const SizedBox(height: 16),

                  // 3. Narrative Breakdown Cards
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(color: RisproColors.secondary),
                      ),
                    )
                  else ...[
                    _sectionEvaluationCard(
                      icon: Icons.insights_rounded,
                      title: "1. Dampak Keputusan Proyek",
                      content: analysis?["summary"],
                      accentColor: RisproColors.secondary,
                    ),

                    _sectionEvaluationCard(
                      icon: Icons.engineering_rounded,
                      title: "2. Efektivitas Mitigasi",
                      content: analysis?["mitigation"],
                      accentColor: RisproColors.accentDark,
                    ),

                    _sectionEvaluationCard(
                      icon: Icons.trending_up_rounded,
                      title: "3. Evaluasi Strategi Tata Kelola",
                      content: analysis?["recommendation"],
                      accentColor: RisproColors.primary,
                    ),

                    const SizedBox(height: 8),

                    // 4. Learning Insight Callout
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: RisproColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: RisproColors.border, width: 1.2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: RisproColors.accentDark, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pelajaran Utama (Key Takeaway):",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: RisproColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  analysis?["learningInsight"] ?? "-",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: RisproColors.textMain,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade(delay: 350.ms),
                  ],

                  const SizedBox(height: 24),

                  // 5. CTA Button
                  RisproButton(
                    text: "Ambil Sertifikat Penyelesaian",
                    icon: Icons.workspace_premium_rounded,
                    isTrailingIcon: true,
                    variant: RisproButtonVariant.accent,
                    height: 58,
                    fontSize: 17,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/certificate',
                        arguments: {
                          "score": score,
                          "rank": getRankLabel(score),
                          "profile": analysis?["profile"] ?? "Risk Learner",
                          "completedPosts": 5,
                          "total": {"cost": cost, "time": time, "risk": risk},
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

  Widget _metricCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RisproColors.border, width: 1),
        boxShadow: RisproColors.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 10, color: RisproColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionEvaluationCard({
    required IconData icon,
    required String title,
    required String? content,
    required Color accentColor,
  }) {
    return RisproCard(
      accentColor: accentColor,
      padding: const EdgeInsets.all(18),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: RisproColors.textMain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content ?? "-",
            style: GoogleFonts.poppins(
              color: RisproColors.textSecondary,
              height: 1.5,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
