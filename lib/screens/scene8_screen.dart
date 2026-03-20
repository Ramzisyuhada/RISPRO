import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Scene8Screen extends StatelessWidget {
  const Scene8Screen({super.key});

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
                "Refleksi Pembelajaran",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              /// 📊 POINT LIST (UPGRADE)
              _buildPoint("Dampak keputusan terhadap proyek"),
              _buildPoint("Efektivitas mitigasi"),
              _buildPoint("Evaluasi strategi"),

              const SizedBox(height: 20),

              /// 🧠 DESKRIPSI
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
                child: const Text(
                  "Pembelajaran berbasis simulasi memungkinkan mahasiswa "
                  "mengalami langsung konsekuensi keputusan, bukan sekadar membaca kasus.",
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.2),

              const Spacer(),

              /// 🔁 BUTTONS
              Column(
                children: [

                  /// 🔄 ULANGI SIMULASI
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/game',
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
                        "Ulangi Simulasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ SELESAI
                  GestureDetector(
                    onTap: () {
 Navigator.pushNamedAndRemoveUntil(
    context,
    '/',
    (route) => false,
  );                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        "Selesai",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 POINT ITEM (UPGRADE)
  Widget _buildPoint(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1E3A8A), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: -0.2);
  }
}