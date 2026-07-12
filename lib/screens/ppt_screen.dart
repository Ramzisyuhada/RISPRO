import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PptScreen extends StatefulWidget {
  const PptScreen({super.key});

  @override
  State<PptScreen> createState() => _PptScreenState();
}

class _PptScreenState extends State<PptScreen> {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

final List<String> slides = [
  'assets/ppt/1.jpg',
  'assets/ppt/2.jpg',
  'assets/ppt/3.jpg',
  'assets/ppt/4.jpg',
  'assets/ppt/5.jpg',
  'assets/ppt/6.jpg',
  'assets/ppt/7.jpg',
  'assets/ppt/8.jpg',
  'assets/ppt/9.jpg',
  'assets/ppt/10.jpg',
  'assets/ppt/11.jpg',
  'assets/ppt/12.jpg',
  'assets/ppt/13.jpg',
  'assets/ppt/14.jpg',
  'assets/ppt/15.jpg',
  'assets/ppt/16.jpg',
  'assets/ppt/17.jpg',
  'assets/ppt/18.jpg',
  'assets/ppt/19.jpg',
  'assets/ppt/20.jpg',
  'assets/ppt/21.jpg',
];

  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Materi PPT",
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Slide Pembelajaran"),
            const SizedBox(height: 15),
            _pptViewer().animate().fade(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }

  /// 📊 PPT VIEWER (IMAGE BASED)
  Widget _pptViewer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              slides[currentSlide],
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 15),

          /// SLIDE INDICATOR
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Slide ${currentSlide + 1} dari ${slides.length}",
              style: const TextStyle(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// SLIDER CONTROL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: currentSlide > 0
                    ? () {
                        setState(() {
                          currentSlide--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text("Sebelumnya"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: Colors.grey[300],
                ),
              ),
              ElevatedButton.icon(
                onPressed: currentSlide < slides.length - 1
                    ? () {
                        setState(() {
                          currentSlide++;
                        });
                      }
                    : null,
                icon: const Text("Berikutnya"),
                label: const Icon(Icons.arrow_forward),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: Colors.grey[300],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
