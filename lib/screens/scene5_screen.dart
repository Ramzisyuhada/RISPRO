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

class Scene5Screen extends StatefulWidget {
  final VendorData vendor;
  final Map prevImpact;

  const Scene5Screen({
    super.key,
    required this.vendor,
    required this.prevImpact,
  });

  @override
  State<Scene5Screen> createState() => _Scene5ScreenState();
}

class _Scene5ScreenState extends State<Scene5Screen> {
  final aiService = SimulationAIService();

  String? selected;
  String? feedback;
  String displayedText = "";
  String fullText = "";
  Map<String, dynamic>? selectedImpact;

  bool readyToNext = false;
  bool isLoading = true;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadScene();
  }

  void loadScene() async {
    final result = await aiService.generateScene5Uncertainty(
      widget.vendor,
      widget.prevImpact,
    );

    if (!mounted) return;
    setState(() {
      data = result;
      fullText = result["scene"] ?? "Terjadi kondisi ketidakpastian tinggi (force majeure/cuaca ekstrem). Pilih langkah adaptif.";
      isLoading = false;
    });

    _typingEffect();
  }

  void _typingEffect() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  void chooseAI(Map choice, int index) {
    if (selected != null) return;

    HapticFeedback.mediumImpact();
    final impact = choice["impact"] as Map<String, dynamic>;

    if (index == 0) {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      selected = index.toString();
      feedback = choice["feedback"];
      selectedImpact = impact;
    });

    aiService.addHistory(
      scene: "Scene 5 - Uncertainty",
      choice: choice["text"],
      impact: impact,
    );

    aiService.updateImpact(selectedImpact!);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        readyToNext = true;
      });
    });
  }

  void goNext() {
    if (!readyToNext) return;

    Navigator.pushReplacementNamed(
      context,
      '/scene7',
      arguments: {
        "total": {
          "cost": aiService.totalImpact["cost"] ?? 0,
          "time": aiService.totalImpact["time"] ?? 0,
          "risk": aiService.totalImpact["risk"] ?? 0,
        }
      },
    );
  }

  String getCharacterImage() {
    if (selected == "0") {
      return "assets/AssetGame/player_woried.png";
    } else if (selected == "1") {
      return "assets/AssetGame/player_thinking.png";
    } else if (selected == "2") {
      return "assets/AssetGame/player_confident.png";
    }
    return "assets/AssetGame/player_thinking.png";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goNext,
      child: Scaffold(
        backgroundColor: RisproColors.background,
        appBar: const RisproAppBar(title: "Pos 4: Uncertainty Decision"),
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: RisproColors.uncertainty),
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
                          // 1. Progress Journey Header
                          const RisproProgressJourney(
                            currentStep: 4,
                            totalSteps: 5,
                            stageName: "Uncertainty (Ketidakpastian Tinggi)",
                            subtitle: "Informasi terbatas. Ambil keputusan adaptif & tanggap risiko.",
                          ),

                          const SizedBox(height: 14),

                          // 2. State Badge & Vendor Card Snippet
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
                                    color: RisproColors.uncertaintyBg,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: RisproColors.uncertainty.withValues(alpha: 0.3)),
                                  ),
                                  child: const Icon(Icons.help_outline_rounded, color: RisproColors.uncertainty, size: 24),
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
                                            stateType: RisproDecisionStateType.uncertainty,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Situasi: Kondisi Eksternal Tidak Terduga",
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

                          // 3. Narrative Dialogue & Dynamic Character
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
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Image.asset(
                                      getCharacterImage(),
                                      key: ValueKey(selected),
                                      height: 52,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Skenario Ketidakpastian Ekstrem",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: RisproColors.uncertainty,
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
                              "Tentukan Respons Adaptif Proyek:",
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
                                  subtitle: "Pilihan fleksibel dalam kondisi minim data",
                                  impact: choice["impact"] as Map<String, dynamic>?,
                                  isSelected: selected == index.toString(),
                                  onTap: () => chooseAI(choice, index),
                                );
                              },
                            ),
                          ],

                          // 5. Feedback Callout
                          if (feedback != null) ...[
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: RisproColors.uncertaintyBg,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: RisproColors.uncertainty.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: RisproColors.uncertainty.withValues(alpha: 0.15),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.psychology_rounded,
                                    color: RisproColors.uncertainty,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Analisis Respons Ketidakpastian",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF5A2A9A),
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
                                      border: Border.all(color: RisproColors.uncertainty.withValues(alpha: 0.4)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Ketuk layar untuk lanjut ke Analisis Profil Risiko →",
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