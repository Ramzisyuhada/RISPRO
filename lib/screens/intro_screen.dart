import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/vendor_data.dart';
import '../domain/service/simulation_ai_service.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_badge.dart';
import '../widgets/vendor_card.dart';

class SimulationIntroScreen extends StatefulWidget {
  const SimulationIntroScreen({super.key});

  @override
  State<SimulationIntroScreen> createState() => _SimulationIntroScreenState();
}

class _SimulationIntroScreenState extends State<SimulationIntroScreen> {
  int step = 0;
  String displayedText = "";

  VendorData? vendor;
  final aiService = SimulationAIService();

  final List<Map<String, String>> scenes = [
    {
      "text": "Anda ditunjuk sebagai Project Manager proyek layanan publik digital pemerintah.",
      "char": "assets/AssetGame/player_normal.png"
    },
    {
      "text": "Proyek ini melibatkan banyak stakeholder dengan ekspektasi tinggi dan berbagai risiko dinamis.",
      "char": "assets/AssetGame/player_thinking.png"
    },
    {
      "text": "Keputusan Anda dalam mengelola biaya, waktu, dan risiko akan menentukan kelayakan proyek.",
      "char": "assets/AssetGame/player_woried.png"
    },
    {
      "text": "Apakah Anda siap mengambil keputusan strategis demi keberhasilan layanan publik?",
      "char": "assets/AssetGame/player_confident.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTyping();
    loadVendor();
  }

  void loadVendor() async {
    final data = await aiService.generateVendor();
    if (!mounted) return;
    setState(() {
      vendor = data;
    });
  }

  void _startTyping() async {
    displayedText = "";
    final fullText = scenes[step]["text"]!;

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      if (!mounted) return;

      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  void nextStep() {
    if (step < scenes.length - 1) {
      setState(() => step++);
      _startTyping();
    } else {
      if (vendor != null) {
        Navigator.pushNamed(
          context,
          '/scene2',
          arguments: vendor,
        );
      }
    }
  }

  void showVendorDetail() {
    if (vendor == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        final screenHeight = MediaQuery.of(context).size.height;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Container(
              padding: const EdgeInsets.all(24),
              height: math.min(screenHeight * 0.65, 540),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: RisproColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Profil Mitra Vendor",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: RisproColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: RisproColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: RisproColors.border, width: 1.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(vendor!.image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    vendor!.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: RisproColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      const RisproTag(
                        label: "Mitra Resmi",
                        color: RisproColors.secondary,
                        icon: Icons.verified_rounded,
                      ),
                      RisproTag(
                        label: "Risiko: ${vendor!.riskLevel.toUpperCase()}",
                        color: vendor!.riskLevel == "high"
                            ? RisproColors.danger
                            : (vendor!.riskLevel == "medium"
                                ? RisproColors.warning
                                : RisproColors.success),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _metricBadge("Rating", "⭐ ${vendor!.rating.toStringAsFixed(1)}"),
                      _metricBadge("Portofolio", "${vendor!.projects} Proyek"),
                      _metricBadge("Keberhasilan", "${vendor!.successRate}%"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: RisproColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          vendor!.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: RisproColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _metricBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: RisproColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RisproColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: RisproColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: RisproColors.textMain,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scene = scenes[step];
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 700;
    final isShort = size.height < 680;

    return Scaffold(
      body: GestureDetector(
        onTap: nextStep,
        child: Stack(
          children: [
            // Background Game Asset
            Positioned.fill(
              child: Image.asset(
                'assets/AssetGame/Background Game.png',
                fit: BoxFit.cover,
              ),
            ),

            // Subtle readability overlay
            Positioned.fill(
              child: Container(
                color: RisproColors.primaryDark.withValues(alpha: 0.35),
              ),
            ),

            // Vendor Card Top Bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: vendor == null
                  ? const Center(
                      child: CircularProgressIndicator(color: RisproColors.accent),
                    )
                  : VendorCard(
                      vendor: vendor!,
                      onTap: showVendorDetail,
                    ),
            ),

            // Character Asset Display
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  top: isShort ? 20 : 60,
                  bottom: isShort ? 140 : 180,
                ),
                child: Image.asset(
                  scene["char"]!,
                  height: isTablet ? 320 : (isShort ? 200 : 250),
                ).animate(key: ValueKey(step)).fade(duration: 300.ms).scale(),
              ),
            ),

            // Dialog Box Bottom Area
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: RisproColors.border, width: 1.5),
                        boxShadow: RisproColors.prominentShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const RisproDecisionStateBadge(
                                stateType: RisproDecisionStateType.neutral,
                                customLabel: "Briefing Proyek",
                              ),
                              Text(
                                "${step + 1} / ${scenes.length}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: RisproColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            displayedText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: RisproColors.textMain,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ketuk layar untuk melanjutkan",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: RisproColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.touch_app_rounded,
                                size: 16,
                                color: RisproColors.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fade(duration: 400.ms).slideY(begin: 0.2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}