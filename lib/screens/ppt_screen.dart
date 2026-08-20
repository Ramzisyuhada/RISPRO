import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';

class PptScreen extends StatefulWidget {
  const PptScreen({super.key});

  @override
  State<PptScreen> createState() => _PptScreenState();
}

class _PptScreenState extends State<PptScreen> {
  final List<String> slides = List.generate(
    21,
    (index) => 'assets/ppt/${index + 1}.jpg',
  );

  int currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Slide Presentasi"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Slide Frame Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                      boxShadow: RisproColors.cardShadow,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Slide Image Display
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              slides[currentSlide],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: RisproColors.surfaceSubtle,
                                child: Center(
                                  child: Text(
                                    "Slide ${currentSlide + 1}",
                                    style: GoogleFonts.poppins(
                                      color: RisproColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Slide Navigation & Progress
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: RisproColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: RisproColors.border, width: 1),
                              ),
                              child: Text(
                                "Slide ${currentSlide + 1} / ${slides.length}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: RisproColors.primary,
                                ),
                              ),
                            ),

                            // Mini Progress Dots / Indicator
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (currentSlide + 1) / slides.length,
                                    minHeight: 6,
                                    backgroundColor: RisproColors.surfaceSubtle,
                                    color: RisproColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Controls Buttons
                        Row(
                          children: [
                            Expanded(
                              child: RisproButton(
                                text: "Sebelumnya",
                                icon: Icons.arrow_back_rounded,
                                variant: RisproButtonVariant.secondary,
                                height: 50,
                                fontSize: 15,
                                onPressed: currentSlide > 0
                                    ? () => setState(() => currentSlide--)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: RisproButton(
                                text: currentSlide < slides.length - 1
                                    ? "Berikutnya"
                                    : "Selesai",
                                icon: Icons.arrow_forward_rounded,
                                isTrailingIcon: true,
                                variant: RisproButtonVariant.primaryCta,
                                height: 50,
                                fontSize: 15,
                                onPressed: currentSlide < slides.length - 1
                                    ? () => setState(() => currentSlide++)
                                    : () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade().scale(begin: const Offset(0.98, 0.98)),

                  const SizedBox(height: 20),

                  // Tips / Context Callout
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: RisproColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: RisproColors.border, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: RisproColors.secondary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Gunakan tombol navigasi di atas untuk berpindah slide. Materi ini menjadi dasar analisis risiko pada tahap simulasi dan kuis pemahaman.",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: RisproColors.textMain,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
