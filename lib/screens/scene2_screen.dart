import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/vendor_data.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';
import '../widgets/rispro_progress_journey.dart';

class Scene2Screen extends StatefulWidget {
  final VendorData vendor;
  const Scene2Screen({super.key, required this.vendor});

  @override
  State<Scene2Screen> createState() => _Scene2ScreenState();
}

class _Scene2ScreenState extends State<Scene2Screen> {
  List<Map<String, String>> risks = [
    {"text": "Data Vendor", "type": "certainty"},
    {"text": "Cuaca Ekstrem", "type": "uncertainty"},
    {"text": "Keterlambatan Jadwal", "type": "risk"},
    {"text": "Perubahan Pajak", "type": "risk"},
    {"text": "Fluktuasi Harga", "type": "risk"},
  ];

  final Map<String, List<String>> dropped = {
    "certainty": [],
    "risk": [],
    "uncertainty": [],
  };

  Map<String, bool> resultMap = {};
  int correct = 0;

  void handleDrop(Map<String, String> data, String type) {
    if (resultMap.containsKey(data["text"])) return;

    bool isCorrect = data["type"] == type;

    setState(() {
      dropped[type]!.add(data["text"]!);
      resultMap[data["text"]!] = isCorrect;
      risks.removeWhere((r) => r["text"] == data["text"]);
      if (isCorrect) correct++;
    });

    if (resultMap.length == 5) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pushNamed(context, '/scene3', arguments: widget.vendor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Pos 1: Klasifikasi Risiko"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Progress Journey Header
              const RisproProgressJourney(
                currentStep: 1,
                totalSteps: 5,
                stageName: "Identifikasi & Klasifikasi Risiko",
                subtitle: "Tarik item risiko ke kategori yang tepat",
              ),

              const SizedBox(height: 14),

              // Draggable Pool Area
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RisproColors.border, width: 1),
                  boxShadow: RisproColors.cardShadow,
                ),
                child: risks.isEmpty
                    ? Center(
                        child: Text(
                          "Semua risiko telah diklasifikasi! 🎉",
                          style: GoogleFonts.poppins(
                            color: RisproColors.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: risks.map((r) {
                            return Draggable<Map<String, String>>(
                              data: r,
                              feedback: Material(
                                color: Colors.transparent,
                                child: _dragItem(r["text"]!, isDragging: true),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _dragItem(r["text"]!),
                              ),
                              child: _dragItem(r["text"]!),
                            );
                          }).toList(),
                        ),
                      ),
              ),

              const SizedBox(height: 14),

              // Drop Targets Grid (Certainty, Risk, Uncertainty)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.count(
                      crossAxisCount: constraints.maxWidth >= 600 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: constraints.maxWidth >= 600 ? 1.0 : 0.88,
                      children: [
                        _dropZone(
                          title: "Certainty",
                          subtitle: "Data Pasti",
                          type: "certainty",
                          color: RisproColors.certainty,
                          icon: Icons.verified_user_rounded,
                        ),
                        _dropZone(
                          title: "Risk",
                          subtitle: "Dapat Dihitung",
                          type: "risk",
                          color: RisproColors.risk,
                          icon: Icons.warning_amber_rounded,
                        ),
                        _dropZone(
                          title: "Uncertainty",
                          subtitle: "Tidak Pasti",
                          type: "uncertainty",
                          color: RisproColors.uncertainty,
                          icon: Icons.help_outline_rounded,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Score & Next Button Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: RisproColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: RisproColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Akurasi: $correct / 5 Benar",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: RisproColors.textMain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: RisproButton(
                        text: "Lanjut →",
                        height: 44,
                        fontSize: 14,
                        variant: RisproButtonVariant.primaryCta,
                        onPressed: () {
                          Navigator.pushNamed(context, '/scene3', arguments: widget.vendor);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dragItem(String text, {bool isDragging = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDragging ? RisproColors.primary : RisproColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDragging ? RisproColors.accent : RisproColors.border,
          width: isDragging ? 2.0 : 1.2,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: RisproColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ]
            : RisproColors.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.drag_indicator_rounded,
            size: 16,
            color: isDragging ? RisproColors.accent : RisproColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDragging ? Colors.white : RisproColors.textMain,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropZone({
    required String title,
    required String subtitle,
    required String type,
    required Color color,
    required IconData icon,
  }) {
    return DragTarget<Map<String, String>>(
      onAcceptWithDetails: (details) => handleDrop(details.data, type),
      builder: (context, candidate, rejected) {
        final isHovering = candidate.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHovering ? color.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering ? color : color.withValues(alpha: 0.35),
              width: isHovering ? 2.2 : 1.2,
            ),
            boxShadow: RisproColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: color,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: RisproColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Divider(height: 1, color: RisproColors.borderSubtle),
              const SizedBox(height: 8),

              Expanded(
                child: dropped[type]!.isEmpty
                    ? Center(
                        child: Text(
                          "Tarik ke sini",
                          style: GoogleFonts.poppins(
                            color: RisproColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: dropped[type]!.map((item) {
                          final isCorrect = resultMap[item];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isCorrect == true
                                  ? RisproColors.successBg
                                  : RisproColors.dangerBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCorrect == true
                                    ? RisproColors.success.withValues(alpha: 0.4)
                                    : RisproColors.danger.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrect == true
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 16,
                                  color: isCorrect == true
                                      ? RisproColors.success
                                      : RisproColors.danger,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isCorrect == true
                                          ? const Color(0xFF0F5A47)
                                          : const Color(0xFF901F1F),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().scale(duration: 250.ms).fade();
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}