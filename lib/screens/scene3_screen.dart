import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';

class Scene3Screen extends StatefulWidget {
  final VendorData vendor;

  const Scene3Screen({super.key, required this.vendor});

  @override
  State<Scene3Screen> createState() => _Scene3ScreenState();
}

class _Scene3ScreenState extends State<Scene3Screen> {
  static const Color primary = Color(0xFF1E3A8A);

  final aiService = SimulationAIService();
Map? selectedChoice;

  Map<String, dynamic>? data;
  String? feedback;
  String displayedText = "";
  String fullText = "";

  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadScene();
  }

  void loadScene() async {
    final result =
        await aiService.generateScene3Decision(widget.vendor);

    setState(() {
      data = result;
      fullText = result["scene"];
      isLoading = false;
    });

    _typingEffect();
  }

  void _typingEffect() async {
    displayedText = "";

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 18));
      if (!mounted) return;

      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  /// 🔥 PILIHAN
  void choose(Map choice, int index) {
    HapticFeedback.mediumImpact();

    setState(() {
      selectedIndex = index;
          selectedChoice = choice; // 🔥 simpan pilihan

    });

    final impact = choice["impact"];

    print("Cost: ${impact["cost"]}");
    print("Time: ${impact["time"]}");
    print("Risk: ${impact["risk"]}");

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        feedback = choice["feedback"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      /// 🔥 TAMBAHAN: TAP LAYAR UNTUK LANJUT
      body: GestureDetector(
        onTap: () {
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
  },
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔥 HEADER
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scene 3 - Certainty",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: 0.3,
                              backgroundColor:
                                  Colors.grey.shade300,
                              color: primary,
                              minHeight: 6,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ],
                        ).animate().fade().slideX(begin: -0.2),

                        const SizedBox(height: 20),

                        /// 🎓 EDU
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.school,
                                  color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Certainty: keputusan berdasarkan data yang jelas",
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 💼 VENDOR CARD
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primary,
                                Colors.blue.shade400
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset:
                                    const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.business,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.vendor.name,
                                      style:
                                          const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "⭐ ${widget.vendor.rating} | ${widget.vendor.successRate}% success",
                                      style:
                                          const TextStyle(
                                              color: Colors
                                                  .white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fade().slideX(begin: -0.2),

                        const SizedBox(height: 20),

                        /// 🎭 CHARACTER
                        Center(
                          child: Container(
                            padding:
                                const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.08),
                                  blurRadius: 12,
                                )
                              ],
                            ),
                            child: Image.asset(
                              "assets/AssetGame/player_normal.png",
                              height: 90,
                            ),
                          ),
                        )
                            .animate()
                            .fade()
                            .scale(duration: 500.ms)
                            .then()
                            .scaleXY(
                                begin: 1,
                                end: 1.05,
                                duration: 800.ms)
                            .then()
                            .scaleXY(
                                begin: 1.05,
                                end: 1,
                                duration: 800.ms),

                        const SizedBox(height: 16),

                        /// 💬 DIALOG
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.05),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.psychology,
                                  color: primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  displayedText,
                                  style:
                                      const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.black87
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fade().slideY(begin: 0.2),

                        const SizedBox(height: 20),

                        /// 🎯 CHOICES
                        if (feedback == null)
                          ...data!["choices"]
                              .asMap()
                              .entries
                              .map<Widget>((entry) {
                            int index = entry.key;
                            var choice = entry.value;

                            return _eduButton(
                              choice["text"],
                              "Pilih keputusan",
                              Colors.blue,
                              () => choose(choice, index),
                              isSelected:
                                  selectedIndex == index,
                            );
                          }).toList(),

                        /// 🧠 FEEDBACK
                        if (feedback != null) ...[
                          Container(
                            margin:
                                const EdgeInsets.only(top: 20),
                            padding:
                                const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade100,
                                  Colors.blue.shade50
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 40),
                                const SizedBox(height: 10),
                                Text(
                                  feedback!,
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ).animate().scale().fade(),

                          const SizedBox(height: 10),

                          /// 🔥 HINT
                          const Center(
                            child: Text(
                              "Tap layar untuk lanjut...",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],

                        const SizedBox(height: 30),

                        const Text(
                          "Kesimpulan: Certainty berarti mengambil keputusan berdasarkan data yang sudah jelas.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  /// 🔥 BUTTON GAME STYLE (TIDAK DIUBAH)
  Widget _eduButton(
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap, {
    bool isSelected = false,
  }) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setLocalState(() => isHovered = true),
          onExit: (_) => setLocalState(() => isHovered = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? [color.withOpacity(0.4), color.withOpacity(0.2)]
                      : isHovered
                          ? [color.withOpacity(0.25), color.withOpacity(0.1)]
                          : [color.withOpacity(0.1), color.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.green : color,
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: [
                  if (isHovered || isSelected)
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: isSelected ? 16 : 10,
                    )
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_checked,
                    color: isSelected ? Colors.green : color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: color),
                ],
              ),
            ).animate().fade().slideX(begin: 0.2),
          ),
        );
      },
    );
  }
}