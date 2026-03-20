import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';

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
    int cost = clamp(total["cost"] ?? 0);
    int time = clamp(total["time"] ?? 0);
    int risk = clamp(total["risk"] ?? 0);

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

      setState(() {
        analysis = Map<String, dynamic>.from(res);
        analysis!["publicScore"] = localScore;
        isLoading = false;
      });

      startScoreAnimation(localScore);
    } catch (e) {
      final fallback = calculateScore(widget.total);

      setState(() {
        analysis = {
          "publicScore": fallback,
          "summary": "Tidak dapat dianalisis.",
          "mitigation": "Mitigasi tidak optimal.",
          "recommendation": "Perbaiki strategi.",
          "learningInsight":
              "Setiap keputusan memiliki konsekuensi nyata.",
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
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  String getRank(int score) {
    if (score < 40) return "❌ Buruk";
    if (score < 70) return "⚠ Cukup";
    return "🏆 Sangat Baik";
  }

  String getCharacterImage(int score) {
    if (score < 40) return "assets/AssetGame/player_woried.png";
    if (score < 70) return "assets/AssetGame/player_thinking.png";
    return "assets/AssetGame/player_confident.png";
  }

  @override
  Widget build(BuildContext context) {
    final cost = clamp(widget.total["cost"] ?? 0);
    final time = clamp(widget.total["time"] ?? 0);
    final risk = clamp(widget.total["risk"] ?? 0);

    final score = clamp(analysis?["publicScore"] ?? 0);
    final color = getScoreColor(score);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// 🔥 HERO SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), color],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 30,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(
                        getCharacterImage(score),
                        key: ValueKey(score),
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$animatedScore",
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().scale().fade(),
                    const SizedBox(height: 6),
                    Text(
                      getRank(score),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fade().scale(),

              const SizedBox(height: 20),

              /// 🔥 IMPACT CARDS
              Row(
                children: [
                  Expanded(child: _impactCard("Cost", cost, Colors.red)),
                  const SizedBox(width: 10),
                  Expanded(child: _impactCard("Time", time, Colors.orange)),
                  const SizedBox(width: 10),
                  Expanded(child: _impactCard("Risk", risk, Colors.blue)),
                ],
              ),

              const SizedBox(height: 20),

              if (isLoading)
                const CircularProgressIndicator()
              else ...[

                _sectionCard("📊 Dampak Keputusan", analysis?["summary"]),
                _sectionCard("🛠 Efektivitas Mitigasi", analysis?["mitigation"]),
                _sectionCard("📈 Evaluasi Strategi", analysis?["recommendation"]),

                const SizedBox(height: 16),

                /// 🔥 INSIGHT
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: color.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          analysis?["learningInsight"] ?? "-",
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.2),
              ],

              const SizedBox(height: 30),

              /// 🔥 BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Text("Selesai"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 IMPACT CARD
  Widget _impactCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$value%",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 SECTION CARD (FIX KONTRAS)
  Widget _sectionCard(String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value ?? "-",
            style: const TextStyle(
              color: Color(0xFF475569),
              height: 1.5,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}