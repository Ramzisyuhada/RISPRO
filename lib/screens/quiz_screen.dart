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
    "question": "Proyek sektor publik adalah kegiatan yang...",
    "options": [
      "Dilaksanakan oleh perusahaan swasta untuk memperoleh keuntungan",
      "Dikelola oleh pemerintah dan menggunakan anggaran publik",
      "Dilaksanakan oleh organisasi internasional",
      "Dilakukan oleh masyarakat tanpa campur tangan pemerintah"
    ],
    "answer": 1
  },
  {
    "question": "Tujuan utama proyek sektor publik adalah...",
    "options": [
      "Meningkatkan keuntungan perusahaan",
      "Memberikan manfaat bagi masyarakat",
      "Mengurangi jumlah pegawai pemerintah",
      "Mengembangkan bisnis swasta"
    ],
    "answer": 1
  },
  {
    "question": "Berikut yang termasuk contoh proyek sektor publik adalah...",
    "options": [
      "Pembangunan pabrik swasta",
      "Pembangunan rumah sakit pemerintah",
      "Pembukaan restoran",
      "Pembangunan pusat perbelanjaan"
    ],
    "answer": 1
  },
  {
    "question": "Salah satu karakteristik proyek sektor publik adalah...",
    "options": [
      "Tidak diawasi pemerintah",
      "Menggunakan dana pribadi",
      "Melibatkan banyak stakeholder",
      "Tidak membutuhkan perencanaan"
    ],
    "answer": 2
  },
  {
    "question": "Proyek sektor publik memiliki tingkat risiko tinggi karena...",
    "options": [
      "Tidak memerlukan pengawasan",
      "Dipengaruhi faktor sosial dan politik",
      "Tidak membutuhkan dana",
      "Tidak memiliki tujuan jelas"
    ],
    "answer": 1
  },
  {
    "question": "Berikut yang bukan termasuk kompleksitas proyek sektor publik adalah...",
    "options": [
      "Keterbatasan anggaran",
      "Perubahan regulasi",
      "Konflik kepentingan",
      "Stabilitas pasar saham"
    ],
    "answer": 3
  },
  {
    "question": "Risiko dalam proyek dapat berdampak pada...",
    "options": [
      "Biaya, waktu, dan mutu proyek",
      "Jumlah pegawai",
      "Lokasi proyek",
      "Warna bangunan proyek"
    ],
    "answer": 0
  },
  {
    "question": "Risiko proyek dapat didefinisikan sebagai...",
    "options": [
      "Mengukur keberhasilan proyek",
      "Kemungkinan terjadinya peristiwa yang menghambat tujuan proyek",
      "Rencana kerja proyek",
      "Strategi pemasaran proyek"
    ],
    "answer": 1
  },
  {
    "question": "Manajemen risiko adalah proses untuk...",
    "options": [
      "Menghilangkan semua risiko",
      "Mengidentifikasi dan mengendalikan risiko",
      "Menghindari semua proyek",
      "Mengurangi jumlah pekerja"
    ],
    "answer": 1
  },
  {
    "question": "Tujuan utama manajemen risiko adalah...",
    "options": [
      "Menghilangkan seluruh proyek",
      "Memaksimalkan biaya proyek",
      "Meminimalkan dampak negatif risiko",
      "Mengurangi jumlah stakeholder"
    ],
    "answer": 2
  },
  {
    "question": "Berikut tahapan manajemen risiko yang benar adalah...",
    "options": [
      "Identifikasi – Analisis – Evaluasi – Penanganan",
      "Analisis – Perencanaan – Pelaksanaan",
      "Perencanaan – Pengawasan – Evaluasi",
      "Identifikasi – Pelaksanaan – Evaluasi"
    ],
    "answer": 0
  },
  {
    "question": "Tahap pertama dalam manajemen risiko adalah...",
    "options": [
      "Analisis risiko",
      "Evaluasi risiko",
      "Identifikasi risiko",
      "Pengendalian proyek"
    ],
    "answer": 2
  },
  {
    "question": "Tujuan utama identifikasi risiko adalah...",
    "options": [
      "Menghilangkan risiko",
      "Menemukan risiko yang mungkin terjadi",
      "Menentukan anggaran proyek",
      "Menentukan jadwal proyek"
    ],
    "answer": 1
  },
  {
    "question": "Contoh risiko proyek adalah...",
    "options": [
      "Peningkatan jumlah pegawai",
      "Keterlambatan material",
      "Penambahan fasilitas proyek",
      "Peningkatan kualitas bangunan"
    ],
    "answer": 1
  },
  {
    "question": "Analisis risiko bertujuan untuk...",
    "options": [
      "Menentukan biaya proyek",
      "Mengetahui kemungkinan dan dampak risiko",
      "Menambah jumlah pekerja",
      "Menentukan lokasi proyek"
    ],
    "answer": 1
  },
  {
    "question": "Salah satu metode analisis risiko adalah...",
    "options": [
      "Analisis pasar",
      "Analisis probabilitas",
      "Analisis keuntungan",
      "Analisis promosi"
    ],
    "answer": 1
  },
  {
    "question": "Evaluasi risiko bertujuan untuk...",
    "options": [
      "Menghapus semua risiko",
      "Menentukan prioritas penanganan risiko",
      "Menentukan jumlah pekerja",
      "Menentukan desain proyek"
    ],
    "answer": 1
  },
  {
    "question": "Risiko yang memiliki dampak besar terhadap proyek harus...",
    "options": [
      "Diabaikan",
      "Menjadi prioritas utama",
      "Ditunda",
      "Dihapus dari laporan"
    ],
    "answer": 1
  },
  {
    "question": "Risiko dalam evaluasi biasanya diklasifikasikan menjadi...",
    "options": [
      "Kecil dan besar",
      "Tinggi dan rendah",
      "Rendah, sedang, dan tinggi",
      "Murah dan mahal"
    ],
    "answer": 2
  },
  {
    "question": "Strategi penanganan risiko yang dilakukan dengan menghindari aktivitas berisiko disebut...",
    "options": [
      "Risk Transfer",
      "Risk Avoidance",
      "Risk Acceptance",
      "Risk Reduction"
    ],
    "answer": 1
  },
  {
    "question": "Strategi yang dilakukan dengan mengurangi dampak risiko disebut...",
    "options": [
      "Risk Reduction",
      "Risk Avoidance",
      "Risk Transfer",
      "Risk Acceptance"
    ],
    "answer": 0
  },
  {
    "question": "Strategi mengalihkan risiko kepada pihak lain disebut...",
    "options": [
      "Risk Reduction",
      "Risk Avoidance",
      "Risk Transfer",
      "Risk Acceptance"
    ],
    "answer": 2
  },
  {
    "question": "Contoh Risk Transfer adalah...",
    "options": [
      "Menghentikan proyek",
      "Menggunakan asuransi proyek",
      "Menunda proyek",
      "Menambah pekerja"
    ],
    "answer": 1
  },
  {
    "question": "Risk Acceptance dilakukan apabila...",
    "options": [
      "Risiko sangat besar",
      "Risiko kecil dan sulit dihindari",
      "Risiko tidak diketahui",
      "Risiko tidak penting"
    ],
    "answer": 1
  },
  {
    "question": "Dalam pengambilan keputusan, kondisi certainty terjadi ketika...",
    "options": [
      "Informasi tidak tersedia",
      "Informasi lengkap tersedia",
      "Tidak ada data sama sekali",
      "Semua keputusan bersifat spekulatif"
    ],
    "answer": 1
  },
  {
    "question": "Kondisi risk terjadi ketika...",
    "options": [
      "Informasi cukup untuk memperkirakan probabilitas",
      "Tidak ada informasi",
      "Semua keputusan pasti benar",
      "Tidak ada risiko sama sekali"
    ],
    "answer": 0
  },
  {
    "question": "Kondisi uncertainty terjadi ketika...",
    "options": [
      "Informasi lengkap tersedia",
      "Probabilitas dapat dihitung dengan pasti",
      "Informasi terbatas dan probabilitas tidak diketahui",
      "Tidak ada keputusan yang diambil"
    ],
    "answer": 2
  },
  {
    "question": "Individu yang cenderung menghindari risiko disebut...",
    "options": [
      "Risk Neutral",
      "Risk Seeker",
      "Risk Averse",
      "Risk Taker"
    ],
    "answer": 2
  },
  {
    "question": "Individu yang bersikap netral terhadap risiko disebut...",
    "options": [
      "Risk Neutral",
      "Risk Seeker",
      "Risk Avoider",
      "Risk Analyst"
    ],
    "answer": 0
  },
  {
    "question": "Manajemen risiko yang baik dalam proyek publik dapat meningkatkan...",
    "options": [
      "Pemborosan anggaran",
      "Kegagalan proyek",
      "Keberhasilan proyek pembangunan",
      "Ketidakpercayaan masyarakat"
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