import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';

class Scene4Screen extends StatefulWidget {
  final VendorData vendor;
  final String lastChoice;
  final Map impact;

  const Scene4Screen({
    super.key,
    required this.vendor,
    required this.lastChoice,
    required this.impact,
  });

  @override
  State<Scene4Screen> createState() => _Scene4ScreenState();
}

class _Scene4ScreenState extends State<Scene4Screen> {
  static const Color primary = Color(0xFF1E3A8A);

  final aiService = SimulationAIService();

  String? selected;
  String? feedback;
  String displayedText = "";
  String fullText = "";

  bool readyToNext = false;
  bool isLoading = true;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadScene();
  }

  void loadScene() async {
    final result = await aiService.generateScene4Risk(
      widget.vendor,
      widget.lastChoice,
      widget.impact,
    );
    print("Scene 4 : " + result.toString());
    setState(() {
      data = result;
      fullText = result["scene"];
      isLoading = false;
    });

    _typingEffect();
  }

  void _typingEffect() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 18));
      if (!mounted) return;
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  void chooseAI(Map choice, int index) {
    if (selected != null) return;

    HapticFeedback.mediumImpact();

    setState(() {
      selected = index.toString();
      feedback = choice["feedback"];
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        readyToNext = true;
      });
    });
  }

  void goNext() {
    if (!readyToNext) return;

    Navigator.pushReplacementNamed(
      context,
      '/scene5',
      arguments: {
        "vendor": widget.vendor,
        "lastChoice": selected,
        "prevImpact": widget.impact,
      },
    );
  }

  Color getFeedbackColor() {
    if (selected == "0") return Colors.red;
    if (selected == "1") return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goNext,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔥 HEADER
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "⚠ Risk: keputusan dengan konsekuensi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade().slideY(begin: -0.2),

                      const SizedBox(height: 20),

                      /// 🔥 VENDOR (lebih premium)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, Colors.blue.shade400],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.business, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vendor.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "⭐ ${widget.vendor.rating} | ${widget.vendor.successRate}%",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ).animate().scale().fade(),

                      const SizedBox(height: 20),

                      /// 🔥 CHARACTER (idle animasi)
                      Center(
                        child: Image.asset(
                          "assets/AssetGame/player_woried.png",
                          height: 90,
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .moveY(begin: -4, end: 4, duration: 1200.ms)
                            .then()
                            .moveY(begin: 4, end: -4, duration: 1200.ms),
                      ),

                      const SizedBox(height: 16),

                      /// 🔥 STORY (lebih readable)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Text(
                          displayedText,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                      ).animate().fade(),

                      const SizedBox(height: 20),

                      /// 🔥 OPTIONS AI
                      if (feedback == null)
                        ...data!["choices"].asMap().entries.map<Widget>((entry) {
                          int index = entry.key;
                          var choice = entry.value;

                          return _optionAI(choice, index);
                        }).toList(),

                      /// 🔥 FEEDBACK CENTERED (IMPROVED)
                      if (feedback != null)
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: getFeedbackColor().withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        getFeedbackColor().withOpacity(0.4),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          getFeedbackColor().withOpacity(0.2),
                                      blurRadius: 20,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      selected == "0"
                                          ? Icons.trending_up
                                          : selected == "1"
                                              ? Icons.engineering
                                              : Icons.warning,
                                      size: 32,
                                      color: getFeedbackColor(),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      feedback!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        fontWeight: FontWeight.w600,
                                        color: getFeedbackColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().scale().fade(),

                              const SizedBox(height: 20),

                              if (readyToNext)
                                const Text(
                                  "Tap dimana saja untuk lanjut →",
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    .animate(onPlay: (c) => c.repeat())
                                    .fade(begin: 0.3, end: 1),
                            ],
                          ),
                        ),

                      const SizedBox(height: 30),

                      const Center(
                        child: Text(
                          "Kesimpulan: setiap keputusan memiliki trade-off.",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// 🔥 OPTION AI (lebih interaktif)
  Widget _optionAI(Map choice, int index) {
    final isSelected = selected == index.toString();

    return GestureDetector(
      onTap: () => chooseAI(choice, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
              )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.circle,
                color: isSelected ? Colors.orange : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice["text"],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.orange
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
      ).animate().fade().slideX(begin: 0.2),
    );
  }
}