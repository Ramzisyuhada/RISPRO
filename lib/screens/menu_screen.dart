import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // 🎨 WARNA (ambil dari karakter)
  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "RISPRO",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    "Simulation",
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  )
                ],
              )
                  .animate()
                  .fade(duration: 400.ms)
                  .slideY(begin: -0.2),

              const SizedBox(height: 30),

              /// 🧠 TITLE
              const Text(
                "Risk Decision Simulator",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              )
                  .animate()
                  .fade(delay: 200.ms)
                  .slideY(begin: 0.2),

              const SizedBox(height: 10),

              /// 📘 SUBTITLE (SUDAH SESUAI PDF)
              const Text(
                "Latih pengambilan keputusan manajemen risiko melalui simulasi proyek sektor publik.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              )
                  .animate()
                  .fade(delay: 300.ms),

              const SizedBox(height: 20),

              /// 🤖 LOTTIE CHARACTER
              SizedBox(
                height: 160,
                child: Lottie.asset(
                  'assets/AssetGame/Robots.json',
                  repeat: true,
                ),
              )
                  .animate()
                  .fade(delay: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9)),

              const SizedBox(height: 20),

              /// 📄 CONTEXT (SUDAH SESUAI KONSEP)
              const Text(
                "Anda berperan sebagai Manajer Proyek sektor publik.\nSetiap keputusan diambil dalam kondisi certainty, risk, dan uncertainty.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textPrimary,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fade(delay: 500.ms),

              const Spacer(),

              /// 🎯 CTA
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.pushNamed(context, '/game');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
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
                  .fade(delay: 600.ms)
                  .scale(begin: const Offset(0.95, 0.95))
                  .then()
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.02, 1.02),
                    duration: 1200.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.02, 1.02),
                    end: const Offset(1, 1),
                    duration: 1200.ms,
                  ),

              const SizedBox(height: 16),

              /// 🔻 MENU BAWAH
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
          _BottomItem(icon: Icons.menu_book, label: "Materi", route: '/materi'),
_BottomItem(icon: Icons.quiz, label: "Kuis", route: '/quiz'),
_BottomItem(icon: Icons.info, label: "Tentang", route: '/about'),
                ],
              )
                  .animate()
                  .fade(delay: 700.ms)
                  .slideY(begin: 0.3),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}