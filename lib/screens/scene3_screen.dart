import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/vendor_data.dart';
import '../domain/service/simulation_ai_service.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_badge.dart';
import '../widgets/rispro_decision_card.dart';
import '../widgets/rispro_progress_journey.dart';

class Scene3Screen extends StatefulWidget {
  final VendorData vendor;

  const Scene3Screen({super.key, required this.vendor});

  @override
  State<Scene3Screen> createState() => _Scene3ScreenState();
}

class _Scene3ScreenState extends State<Scene3Screen> {
  final aiService = SimulationAIService();
  Map? selectedChoice;
  Map<String, dynamic>? selectedImpact;

  Map<String, dynamic>? data;
  String? feedback;
  String displayedText = "";
  String fullText = "";

  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    aiService.resetImpact();
    loadScene();
  }

  void loadScene() async {
    final result = await aiService.generateScene3Decision(widget.vendor);

    if (!mounted) return;
    setState(() {
      data = result;
      fullText = result["narration"] ?? "Evaluasi data vendor dan tentukan keputusan pengadaan proyek.";
      isLoading = false;
    });

    _typingEffect();
  }

  void _typingEffect() async {
    displayedText = "";

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;

      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  void choose(Map choice, int index) {
    HapticFeedback.mediumImpact();
    final impact = choice["impact"] as Map<String, dynamic>;

    setState(() {
      selectedIndex = index;
      selectedChoice = choice;
      selectedImpact = impact;
    });

    aiService.addHistory(
      scene: "Scene 3 - Certainty",
      choice: choice["text"],
      impact: impact,
    );

    aiService.updateImpact(selectedImpact!);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        feedback = choice["feedback"];
      });
    });
  }

  void navigateNext() {
    if (feedback != null && selectedChoice != null) {
      Navigator.pushNamed(
        context,
        '/scene4',
        arguments: {
          "vendor": widget.vendor,
          "lastChoice": selectedChoice?["text"] ?? "-",
          "impact": selectedChoice?["impact"] ?? {
            "cost": 0,
            "time": 0,
            "risk": 0,
          },
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateNext,
      child: Scaffold(
        backgroundColor: RisproColors.background,
        appBar: const RisproAppBar(title: "Pos 2: Certainty Decision"),
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: RisproColors.secondary),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Journey Progress Indicator
                          const RisproProgressJourney(
                            currentStep: 2,
                            totalSteps: 5,
                            stageName: "Certainty (Kondisi Informasi Pasti)",
                            subtitle: "Data pengadaan lengkap. Tentukan keputusan optimal.",
                          ),

                          const SizedBox(height: 14),

                          // 2. Decision State Badge & Vendor Snippet
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: RisproColors.border, width: 1),
                              boxShadow: RisproColors.cardShadow,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: RisproColors.certaintyBg,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: RisproColors.certainty.withValues(alpha: 0.3)),
                                  ),
                                  child: const Icon(Icons.verified_user_rounded, color: RisproColors.certainty, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.vendor.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: RisproColors.textMain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const RisproDecisionStateBadge(
                                            stateType: RisproDecisionStateType.certainty,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "⭐ ${widget.vendor.rating} | Portofolio: ${widget.vendor.projects} Proyek | Sukses: ${widget.vendor.successRate}%",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: RisproColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fade().slideY(begin: -0.1),

                          const SizedBox(height: 14),

                          // 3. Character & Dialogue Narrative Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: RisproColors.border, width: 1.2),
                              boxShadow: RisproColors.cardShadow,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: RisproColors.surfaceSubtle,
                                  child: Image.asset(
                                    "assets/AssetGame/player_normal.png",
                                    height: 52,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Skenario Keputusan",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: RisproColors.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        displayedText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: RisproColors.textMain,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fade(delay: 200.ms),

                          const SizedBox(height: 20),

                          // 4. Decision Choices List
                          if (feedback == null && data != null && data!["choices"] != null) ...[
                            Text(
                              "Tentukan Pilihan Keputusan:",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: RisproColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(
                              (data!["choices"] as List).length,
                              (index) {
                                final choice = data!["choices"][index] as Map;
                                return RisproDecisionCard(
                                  index: index,
                                  text: choice["text"] ?? "-",
                                  subtitle: "Pilih untuk melihat konsekuensi trade-off",
                                  impact: choice["impact"] as Map<String, dynamic>?,
                                  isSelected: selectedIndex == index,
                                  onTap: () => choose(choice, index),
                                );
                              },
                            ),
                          ],

                          // 5. Feedback Callout when choice selected
                          if (feedback != null) ...[
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: RisproColors.certaintyBg,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: RisproColors.certainty.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: RisproColors.certainty.withValues(alpha: 0.15),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: RisproColors.certainty,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Analisis Konsekuensi Keputusan",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F5A47),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    feedback!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: RisproColors.textMain,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: RisproColors.certainty.withValues(alpha: 0.4)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Ketuk layar untuk lanjut ke Pos 3 (Risk) →",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: RisproColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().scale(duration: 350.ms).fade(),
                          ],

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}