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

  void loadAnalysis() async {
    final result = await aiService.generateFinalAnalysis(widget.total);

    final int score =
        ((100 - (widget.total["risk"] ?? 0)).clamp(0, 100)).toInt();

    setState(() {
      analysis = result;
      isLoading = false;
    });

    startScoreAnimation(score);
  }

  void startScoreAnimation(int finalScore) async {
    for (int i = 0; i <= finalScore; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      if (!mounted) return;

      setState(() {
        animatedScore = i;
      });
    }
  }

  /// 🔥 COLOR & RANK
  Color getScoreColor(int score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }

  String getRank(int score) {
    if (score < 40) return "❌ Poor Decision";
    if (score < 70) return "⚠ Average";
    return "🏆 Excellent";
  }

  @override
  Widget build(BuildContext context) {
    final cost = widget.total["cost"] ?? 0;
    final time = widget.total["time"] ?? 0;
    final risk = widget.total["risk"] ?? 0;

    final scoreColor = getScoreColor(animatedScore);
    final rank = getRank(animatedScore);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TITLE
              const Text(
                "📊 Dashboard Hasil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ).animate().fade().slideY(begin: -0.2),

              const SizedBox(height: 20),

              /// 🔥 SCORE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scoreColor.withOpacity(0.7),
                      scoreColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: scoreColor.withOpacity(0.4),
                      blurRadius: 25,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Public Accountability Score",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$animatedScore",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().scale().fade(),
                    const SizedBox(height: 6),
                    Text(
                      rank,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().scale().fade(),

              const SizedBox(height: 20),

              /// 🔥 METRICS
              _bar("Cost Overrun", cost, Colors.red),
              _bar("Time Delay", time, Colors.orange),
              _bar("Risk Exposure", risk, Colors.blue),

              const SizedBox(height: 20),

              /// 🔥 ANALYSIS CARD (UPGRADED)
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _analysisItem(
                            icon: Icons.psychology,
                            title: "Gaya",
                            value: analysis?["style"],
                            color: Colors.purple,
                          ),

                          const Divider(height: 20),

                          _analysisItem(
                            icon: Icons.bar_chart,
                            title: "Ringkasan",
                            value: analysis?["summary"],
                            color: Colors.blue,
                          ),

                          const Divider(height: 20),

                          _analysisItem(
                            icon: Icons.lightbulb,
                            title: "Rekomendasi",
                            value: analysis?["recommendation"],
                            color: Colors.amber,
                          ),

                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _badgeModern("Risk", analysis?["riskLevel"]),
                              _badgeModern("Efficiency",
                                  analysis?["efficiency"]),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fade().slideY(begin: 0.2),

              const Spacer(),

              /// 🔥 BUTTON
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/scene7');
                  },
                  child: const Text(
                    "Lanjut",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 BAR ANIMASI
  Widget _bar(String title, int value, Color color) {
    final percent = (value / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${(percent * 100).toInt()}%",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 12,
                color: color,
                backgroundColor: color.withOpacity(0.15),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
      ],
    ).animate().fade().slideX(begin: -0.2);
  }

  /// 🔥 ANALYSIS ITEM
  Widget _analysisItem({
    required IconData icon,
    required String title,
    required String? value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value ?? "-",
                style: const TextStyle(
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔥 BADGE MODERN
  Widget _badgeModern(String label, String? value) {
    Color color;
    IconData icon;

    switch (value) {
      case "high":
        color = Colors.red;
        icon = Icons.trending_up;
        break;
      case "medium":
        color = Colors.orange;
        icon = Icons.trending_flat;
        break;
      default:
        color = Colors.green;
        icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            "$label: $value",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().scale().fade();
  }
}