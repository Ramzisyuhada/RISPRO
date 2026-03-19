import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔙 BACK
              IconButton(
                icon: const Icon(Icons.arrow_back, color: textPrimary),
                onPressed: () => Navigator.pop(context),
              ),

              /// 🧠 HERO
              _heroHeader(),

              const SizedBox(height: 20),

              /// 📱 ABOUT
              _sectionCard(
                icon: Icons.info_outline,
                title: "Apa itu RISPRO?",
                content:
                    "RISPRO adalah aplikasi simulasi pengambilan keputusan manajemen risiko berbasis AI untuk proyek sektor publik.",
              ).animate().fade(delay: 200.ms),

              const SizedBox(height: 16),

              /// 🎯 TUJUAN
              _sectionCard(
                icon: Icons.flag,
                title: "Tujuan",
                content:
                    "Melatih kemampuan analisis risiko dan pengambilan keputusan melalui simulasi interaktif.",
              ).animate().fade(delay: 300.ms),

              const SizedBox(height: 16),

              /// ⚙️ CARA KERJA
              _sectionCard(
                icon: Icons.settings,
                title: "Cara Kerja",
                content:
                    "AI menghasilkan skenario proyek, pengguna memilih keputusan, lalu sistem memberikan feedback dan analisis risiko.",
              ).animate().fade(delay: 400.ms),

              const SizedBox(height: 16),

              /// 🚀 FITUR
              _sectionCard(
                icon: Icons.star,
                title: "Fitur Utama",
                content:
                    "Simulasi berbasis skenario, AI feedback, klasifikasi risiko, dan analisis profil pengguna.",
              ).animate().fade(delay: 500.ms),

              const SizedBox(height: 20),

              /// 👨‍💻 TEAM (NO IMAGE)
              _teamSection().animate().fade(delay: 600.ms),

              const SizedBox(height: 30),

              /// 🎯 BUTTON
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.pushNamed(context, '/game');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "Mulai Simulasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fade(delay: 700.ms)
                  .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 HERO HEADER
  Widget _heroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "RISPRO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Risk Decision Simulator",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: -0.2);
  }

  /// 🔹 SECTION CARD
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 👨‍💻 TEAM SECTION (INITIAL AVATAR)
  Widget _teamSection() {
    final team = [
      {"name": "Ramzi Syuhada", "role": "Lead Developer"},
      {"name": "Alya Putri", "role": "UI/UX Designer"},
      {"name": "Budi Santoso", "role": "Backend Engineer"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tim Pengembang",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: team.length,
            itemBuilder: (context, index) {
              final member = team[index];

              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    /// 🔹 AVATAR INITIAL
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: primary.withOpacity(0.1),
                      child: Text(
                        member["name"]![0],
                        style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// NAMA
                    Text(
                      member["name"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// ROLE
                    Text(
                      member["role"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}