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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final horizontalPadding = isTablet ? 40.0 : 24.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isTablet ? 28 : 10,
                  ),
                  child: isTablet
                      ? _TabletLayout(onStart: () {
                          Navigator.pushNamed(context, '/game');
                        })
                      : _MobileLayout(onStart: () {
                          Navigator.pushNamed(context, '/game');
                        }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final VoidCallback onStart;

  const _MobileLayout({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "RISPRO",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: MenuScreen.textPrimary,
              ),
            ),
            Text(
              "Simulation",
              style: TextStyle(
                fontSize: 13,
                color: MenuScreen.textSecondary,
              ),
            )
          ],
        )
            .animate()
            .fade(duration: 400.ms)
            .slideY(begin: -0.2),

        const SizedBox(height: 30),

        const Text(
          "Risk Decision Simulator",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: MenuScreen.textPrimary,
          ),
        )
            .animate()
            .fade(delay: 200.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 10),

        const Text(
          "Latih pengambilan keputusan manajemen risiko melalui simulasi proyek sektor publik.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: MenuScreen.textSecondary,
          ),
        ).animate().fade(delay: 300.ms),

        const SizedBox(height: 20),

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

        const Text(
          "Anda berperan sebagai Manajer Proyek sektor publik.\nSetiap keputusan diambil dalam kondisi certainty, risk, dan uncertainty.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: MenuScreen.textPrimary,
            height: 1.5,
          ),
        ).animate().fade(delay: 500.ms),

        const Spacer(),

        _StartButton(onTap: onStart)
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
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final VoidCallback onStart;

  const _TabletLayout({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "RISPRO",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: MenuScreen.textPrimary,
              ),
            ),
            Text(
              "Simulation",
              style: TextStyle(
                fontSize: 14,
                color: MenuScreen.textSecondary,
              ),
            )
          ],
        )
            .animate()
            .fade(duration: 400.ms)
            .slideY(begin: -0.2),

        const SizedBox(height: 28),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Risk Decision Simulator",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: MenuScreen.textPrimary,
                    ),
                  )
                      .animate()
                      .fade(delay: 200.ms)
                      .slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  const Text(
                    "Latih pengambilan keputusan manajemen risiko melalui simulasi proyek sektor publik.",
                    style: TextStyle(
                      fontSize: 16,
                      color: MenuScreen.textSecondary,
                      height: 1.5,
                    ),
                  ).animate().fade(delay: 300.ms),

                  const SizedBox(height: 20),

                  const Text(
                    "Anda berperan sebagai Manajer Proyek sektor publik.\nSetiap keputusan diambil dalam kondisi certainty, risk, dan uncertainty.",
                    style: TextStyle(
                      fontSize: 16,
                      color: MenuScreen.textPrimary,
                      height: 1.5,
                    ),
                  ).animate().fade(delay: 400.ms),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 280,
                      child: _StartButton(onTap: onStart),
                    ),
                  )
                      .animate()
                      .fade(delay: 500.ms)
                      .scale(begin: const Offset(0.96, 0.96)),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      _BottomItem(icon: Icons.menu_book, label: "Materi", route: '/materi'),
                      _BottomItem(icon: Icons.quiz, label: "Kuis", route: '/quiz'),
                      _BottomItem(icon: Icons.info, label: "Tentang", route: '/about'),
                    ],
                  )
                      .animate()
                      .fade(delay: 600.ms)
                      .slideY(begin: 0.2),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 300,
                child: Lottie.asset(
                  'assets/AssetGame/Robots.json',
                  repeat: true,
                ),
              )
                  .animate()
                  .fade(delay: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ),
          ],
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: MenuScreen.primary,
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