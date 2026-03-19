import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedIndex;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "Apa itu kondisi certainty?",
      "options": [
        "Tidak ada informasi",
        "Informasi lengkap",
        "Tidak pasti",
        "Semua benar"
      ],
      "answer": 1
    },
    {
      "question": "Contoh risk adalah?",
      "options": [
        "Cuaca ekstrem",
        "Keterlambatan material",
        "Bencana alam",
        "Tidak diketahui"
      ],
      "answer": 1
    },
    {
      "question": "Uncertainty berarti?",
      "options": [
        "Data lengkap",
        "Pasti",
        "Data minim",
        "Terukur"
      ],
      "answer": 2
    },
  ];

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedIndex = index;

      if (index == questions[currentIndex]["answer"]) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedIndex = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(score: score, total: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BACK
              IconButton(
                icon: const Icon(Icons.arrow_back, color: textPrimary),
                onPressed: () => Navigator.pop(context),
              ),

              /// PROGRESS
              Text(
                "Soal ${currentIndex + 1}/${questions.length}",
                style: const TextStyle(color: textSecondary),
              ),

              const SizedBox(height: 10),

              TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: 0,
                  end: (currentIndex + 1) / questions.length,
                ),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    color: primary,
                    backgroundColor: primary.withOpacity(0.1),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// QUESTION
              Text(
                q["question"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              )
                  .animate()
                  .fade()
                  .slideY(begin: 0.2),

              const SizedBox(height: 20),

              /// OPTIONS
              ...List.generate(q["options"].length, (index) {
                return _optionButton(
                  text: q["options"][index],
                  index: index,
                  correctIndex: q["answer"],
                );
              }),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionButton({
    required String text,
    required int index,
    required int correctIndex,
  }) {
    bool isSelected = index == selectedIndex;
    bool isCorrect = index == correctIndex;

    Color bgColor = Colors.white;

    if (answered) {
      if (isCorrect) {
        bgColor = Colors.green.shade100;
      } else if (isSelected) {
        bgColor = Colors.red.shade100;
      }
    }

    return GestureDetector(
      onTap: () => selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary.withOpacity(0.2)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 14,
          ),
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05)),
    );
  }
}


/// 🔥 RESULT SCREEN (ANIMATED)
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    double percent = score / total;

    String label;
    if (percent > 0.7) {
      label = "Risk Aware 🔥";
    } else if (percent > 0.4) {
      label = "Cukup Baik 👍";
    } else {
      label = "Perlu Belajar Lagi 📘";
    }

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// SCORE
            Text(
              "$score / $total",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            )
                .animate()
                .scale(duration: 500.ms),

            const SizedBox(height: 10),

            /// LABEL
            Text(label)
                .animate()
                .fade(delay: 300.ms),

            const SizedBox(height: 30),

            /// BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
              ),
              onPressed: () {
  Navigator.popUntil(context, (route) => route.isFirst);
},
              child: const Text("Kembali"),
            )
                .animate()
                .fade(delay: 500.ms)
          ],
        ),
      ),
    );
  }
}