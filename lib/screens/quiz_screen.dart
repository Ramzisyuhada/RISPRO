import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
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

    Future.delayed(const Duration(milliseconds: 700), () {
      if (currentIndex < questions.length - 1) {
        if (!mounted) return;
        setState(() {
          currentIndex++;
          answered = false;
          selectedIndex = null;
        });
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultScreen(score: score, total: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: RisproAppBar(
        title: "Uji Pemahaman",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: RisproColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: RisproColors.border, width: 1),
                ),
                child: Text(
                  "${currentIndex + 1} / ${questions.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: RisproColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / questions.length,
                      minHeight: 8,
                      backgroundColor: RisproColors.surfaceSubtle,
                      color: RisproColors.secondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                      boxShadow: RisproColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: RisproColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "PERTANYAAN ${currentIndex + 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: RisproColors.accentDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q["question"],
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: RisproColors.textMain,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().slideY(begin: 0.1),

                  const SizedBox(height: 20),

                  // Options
                  ...List.generate(q["options"].length, (index) {
                    return _optionButton(
                      text: q["options"][index],
                      index: index,
                      correctIndex: q["answer"],
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
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
    final isSelected = index == selectedIndex;
    final isCorrect = index == correctIndex;

    Color bgColor = Colors.white;
    Color borderColor = RisproColors.border;
    Color textColor = RisproColors.textMain;
    Widget icon = Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: RisproColors.surfaceSubtle,
        shape: BoxShape.circle,
        border: Border.all(color: RisproColors.border, width: 1),
      ),
      child: Center(
        child: Text(
          String.fromCharCode(65 + index), // A, B, C, D
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: RisproColors.primary,
          ),
        ),
      ),
    );

    if (answered) {
      if (isCorrect) {
        bgColor = RisproColors.successBg;
        borderColor = RisproColors.success;
        textColor = const Color(0xFF0F5A47);
        icon = const Icon(Icons.check_circle_rounded, color: RisproColors.success, size: 26);
      } else if (isSelected) {
        bgColor = RisproColors.dangerBg;
        borderColor = RisproColors.danger;
        textColor = const Color(0xFF901F1F);
        icon = const Icon(Icons.cancel_rounded, color: RisproColors.danger, size: 26);
      }
    }

    return GestureDetector(
      onTap: () => selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isSelected || (answered && isCorrect) ? 2.0 : 1.2,
          ),
          boxShadow: RisproColors.cardShadow,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Redesigned Quiz Result Screen
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = score / total;

    String label;
    String description;
    Color accentColor;
    IconData statusIcon;

    if (percent >= 0.75) {
      label = "Strategic Risk Master 🏆";
      description = "Pemahaman teori dan analisis risiko proyek sektor publik Anda sangat solid!";
      accentColor = RisproColors.success;
      statusIcon = Icons.military_tech_rounded;
    } else if (percent >= 0.5) {
      label = "Competent Risk Analyst 👍";
      description = "Cukup baik. Tingkatkan pemahaman pada penanganan kondisi ketidakpastian (Uncertainty).";
      accentColor = RisproColors.accentDark;
      statusIcon = Icons.thumb_up_alt_rounded;
    } else {
      label = "Risk Learner 📘";
      description = "Perlu pendalaman materi konsep risiko ISO 31000 dan simulasi keputusan proyek.";
      accentColor = RisproColors.danger;
      statusIcon = Icons.menu_book_rounded;
    }

    return Scaffold(
      backgroundColor: RisproColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Result Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                      boxShadow: RisproColors.prominentShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(statusIcon, color: accentColor, size: 44),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "Hasil Evaluasi Kuis",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: RisproColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "$score / $total",
                          style: GoogleFonts.poppins(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: RisproColors.primary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: RisproColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 400.ms).fade(),

                  const SizedBox(height: 24),

                  RisproButton(
                    text: "Kembali ke Menu Utama",
                    icon: Icons.home_rounded,
                    variant: RisproButtonVariant.primaryCta,
                    height: 56,
                    fontSize: 16,
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}