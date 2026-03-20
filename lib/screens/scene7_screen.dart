import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Scene7Screen extends StatelessWidget {
  const Scene7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
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

              const SizedBox(height: 20),

              /// 📊 METRICS
              Row(
                children: [
                  _metricCard("Cost", "Tinggi", Colors.red),
                  _metricCard("Risk", "Sedang", Colors.orange),
                  _metricCard("Account", "Baik", Colors.green),
                ],
              ),

              const SizedBox(height: 20),

              /// 🧠 RISK PROFILE
              _riskCard(
                title: "Risk Averse",
                subtitle: "Cenderung menghindari risiko",
                percent: 0.6,
                color: Colors.blue,
                isMain: true,
              ),

              _riskCard(
                title: "Risk Neutral",
                subtitle: "Seimbang dalam keputusan",
                percent: 0.1,
                color: Colors.orange,
              ),

              _riskCard(
                title: "Risk Seeker",
                subtitle: "Berani mengambil risiko tinggi",
                percent: 0.3,
                color: Colors.red,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analisis Pola Keputusan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Anda cenderung berhati-hati dalam mengambil keputusan.\n"
                      "Anda lebih mengutamakan keamanan dibanding risiko tinggi.\n\n"
                      "Namun Anda tetap mampu beradaptasi dalam kondisi tertentu.",
                      style: TextStyle(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.2),

              const Spacer(),

              /// 🎓 KESIMPULAN
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Kesimpulan:\n"
                  "Anda termasuk Risk Averse, yaitu tipe yang cenderung menghindari risiko dan memilih keputusan yang aman.",
                  style: TextStyle(
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
                    '/scene8',
                    (route) => false,
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
    );
  }

  /// 🔥 METRIC CARD (FIXED)
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

  /// 🔥 RISK CARD (UPGRADE)
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
        boxShadow: isMain
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
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
              value: percent,
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