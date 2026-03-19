import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Scene3Screen extends StatefulWidget {
  const Scene3Screen({super.key});

  @override
  State<Scene3Screen> createState() => _Scene3ScreenState();
}

class _Scene3ScreenState extends State<Scene3Screen> {
  static const Color primary = Color(0xFF1E3A8A);

  String? feedback;
  String displayedText = "";

  final String fullText =
      "PT Digital Nusantara memiliki rating 4.8/5 dan telah menyelesaikan lebih dari 120 proyek.\nVendor ini dikenal memiliki rekam jejak yang jelas dan terpercaya.\n\nApa keputusan terbaik yang harus diambil?";

  @override
  void initState() {
    super.initState();
    _typingEffect();
  }

  void _typingEffect() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (!mounted) return;
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  void choose(String type) {
    HapticFeedback.lightImpact();

    String result = "";

    if (type == "yes") {
      result =
          "Keputusan tepat ✅\nAnda menggunakan data yang sudah jelas untuk mengambil keputusan secara efisien.";
    } else if (type == "maybe") {
      result =
          "Keputusan cukup aman 🤔\nNamun proses menjadi lebih lambat karena verifikasi ulang.";
    } else {
      result =
          "Keputusan kurang tepat ❌\nMembuang waktu dengan mencari vendor baru tanpa alasan kuat.";
    }

    setState(() {
      feedback = result;
    });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/result');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🎓 HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Certainty: keputusan berdasarkan data yang jelas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🎭 CHARACTER
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Image.asset(
                    "assets/AssetGame/player_normal.png",
                    height: 90,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ).animate().fade().slideY(begin: -0.2),

              const SizedBox(height: 16),

              /// 💬 KASUS (SUDAH INCLUDE VENDOR)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Kasus",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      displayedText,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🎯 PERTANYAAN
              const Text(
                "Apa keputusan terbaik?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              /// 🎮 PILIHAN
              if (feedback == null) ...[
                _eduButton(
                  "Langsung Kontrak",
                  "Menggunakan data yang sudah jelas",
                  Colors.green,
                  () => choose("yes"),
                ),
                _eduButton(
                  "Audit Ulang",
                  "Memastikan ulang untuk keamanan",
                  Colors.orange,
                  () => choose("maybe"),
                ),
                _eduButton(
                  "Cari Vendor Baru",
                  "Menghindari risiko dengan opsi lain",
                  Colors.red,
                  () => choose("no"),
                ),
              ],

              /// 🧠 FEEDBACK
              if (feedback != null)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    feedback!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ).animate().fade().scale(),

              const Spacer(),

              /// 📘 KESIMPULAN
              const Text(
                "Kesimpulan: Certainty berarti mengambil keputusan berdasarkan data yang sudah jelas dan terpercaya.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 BUTTON EDUKASI
  Widget _eduButton(
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Row(
            children: [

              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}