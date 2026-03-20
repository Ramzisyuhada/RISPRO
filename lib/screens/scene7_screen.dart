import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';

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

  /// 🔥 LOAD AI
  void loadAI() async {
    try {
      final res = await aiService.generateFinalAnalysisScane7(widget.total);

      setState(() {
        result = normalizeResult(
          Map<String, dynamic>.from(res),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        result = normalizeResult(null);
        isLoading = false;
      });
    }
  }

  /// 🔥 NORMALIZE (ANTI ERROR)
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
      "analysis": data["analysis"] ?? "Tidak ada analisis.",
      "impactSummary": data["impactSummary"] ?? "-",
      "recommendation": data["recommendation"] ?? "-",
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = result!["profile"];
    final score = result!["score"];

    final avoidance = (score["avoidance"] as num).toDouble() / 100;
    final balance = (score["balance"] as num).toDouble() / 100;
    final aggressive = (score["aggressive"] as num).toDouble() / 100;

    final riskLevel = result!["riskLevel"];
    final efficiency = result!["efficiency"];
    final publicScore = result!["publicScore"];

    final analysis = result!["analysis"];
    final summary = result!["impactSummary"];
    final recommendation = result!["recommendation"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView( // 🔥 FIX OVERFLOW
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🎓 TITLE
                const Text(
                  "Analisis Profil Risiko",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // const SizedBox(height: 20),

                // /// 📊 METRICS
                // Row(
                //   children: [
                //     _metricCard("Risk", riskLevel.toUpperCase(), Colors.red),
                //     _metricCard("Efficiency", efficiency.toUpperCase(), Colors.orange),
                //     _metricCard("Score", "$publicScore", Colors.green),
                //   ],
                // ),

                const SizedBox(height: 20),

                /// 🧠 RISK PROFILE
                _riskCard(
                  title: "Risk Averse",
                  subtitle: "Cenderung menghindari risiko",
                  percent: avoidance,
                  color: Colors.blue,
                  isMain: profile == "Risk Averse",
                ),

                _riskCard(
                  title: "Risk Neutral",
                  subtitle: "Seimbang dalam keputusan",
                  percent: balance,
                  color: Colors.orange,
                  isMain: profile == "Risk Neutral",
                ),

                _riskCard(
                  title: "Risk Seeker",
                  subtitle: "Berani mengambil risiko tinggi",
                  percent: aggressive,
                  color: Colors.red,
                  isMain: profile == "Risk Seeker",
                ),

                const SizedBox(height: 20),

                /// 🧠 ANALISIS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Analisis Pola Keputusan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        analysis,
                        style: const TextStyle(
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 400.ms).slideY(begin: 0.2),

                const SizedBox(height: 20),

                /// 🎓 KESIMPULAN
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Kesimpulan:\n$summary\n\nRekomendasi:\n$recommendation",
                    style: const TextStyle(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ).animate().fade(duration: 500.ms),

                const SizedBox(height: 20),

                /// 🔁 BUTTON
                GestureDetector(
                  onTap: () {
                   Navigator.pushNamedAndRemoveUntil(
  context,
  '/scene6',
  (route) => false,
  arguments: {
    "total": widget.total,
  },
);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "Lanjut Tahap Terakhir",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 METRIC CARD
  Widget _metricCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
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
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 RISK CARD
  Widget _riskCard({
    required String title,
    required String subtitle,
    required double percent,
    required Color color,
    bool isMain = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isMain ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMain ? color : Colors.black12,
          width: isMain ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMain ? color : Colors.black,
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              minHeight: 10,
              color: color,
              backgroundColor: color.withOpacity(0.2),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: 0.2);
  }
}