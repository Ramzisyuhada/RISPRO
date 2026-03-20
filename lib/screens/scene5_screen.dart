import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/data/vendor_data.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';

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

  /// 🔥 LOAD AI
  void loadScene() async {
    final result = await aiService.generateScene5Uncertainty(
      widget.vendor,
      widget.prevImpact,
    );
    print("Analysis " +result.toString());
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

  /// 🔥 PILIHAN
  void chooseAI(Map choice, int index) {
    if (selected != null) return;

    HapticFeedback.mediumImpact();

    /// 🔥 efek tambahan kalau pilihan buruk
    if (index == 0) {
      HapticFeedback.heavyImpact();
    }

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

//     Navigator.pushReplacementNamed(
//   context,
//   '/scene6',
//   arguments: {
//     "total": {
//       "cost": widget.prevImpact["cost"],
//       "time": widget.prevImpact["time"],
//       "risk": widget.prevImpact["risk"],
//     }
//   },
// );

Navigator.pushReplacementNamed(
    context,
    '/scene7',
    arguments: {
      "total": {
        "cost": widget.prevImpact["cost"] ?? 0,
        "time": widget.prevImpact["time"] ?? 0,
        "risk": widget.prevImpact["risk"] ?? 0,
      }
    },
  );
  }

  /// 🔥 warna feedback
  Color getFeedbackColor() {
    if (selected == "0") return Colors.red;
    if (selected == "1") return Colors.orange;
    return Colors.blue;
  }

  /// 🔥 ekspresi karakter
  String getCharacterImage() {
    if (selected == "0") {
      return "assets/AssetGame/player_woried.png";
    } else if (selected == "1") {
      return "assets/AssetGame/player_thinking.png";
    } else if (selected == "2") {
      return "assets/AssetGame/player_confident.png";
    }
    return "assets/AssetGame/player_woried.png";
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
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.help, color: Colors.purple),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "❓ Uncertainty: kondisi tidak pasti",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B21A8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade().slideY(begin: -0.2),

                      const SizedBox(height: 20),

                      /// 🔥 VENDOR
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
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.business, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              widget.vendor.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate().scale().fade(),

                      const SizedBox(height: 20),

                      /// 🔥 CHARACTER (DYNAMIC EXPRESSION)
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Image.asset(
                            getCharacterImage(),
                            key: ValueKey(selected),
                            height: 110,
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .moveY(begin: -4, end: 4, duration: 1200.ms)
                            .then()
                            .moveY(begin: 4, end: -4, duration: 1200.ms),
                      ),

                      const SizedBox(height: 16),

                      /// 🔥 STORY
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

                      /// 🔥 OPTIONS
                      if (feedback == null)
                        ...data!["choices"].asMap().entries.map<Widget>((entry) {
                          int index = entry.key;
                          var choice = entry.value;
                          return _optionAI(choice, index);
                        }).toList(),

                      /// 🔥 FEEDBACK CENTER
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
                                          ? Icons.warning
                                          : selected == "1"
                                              ? Icons.psychology
                                              : Icons.auto_graph,
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
                          "Keputusan dalam ketidakpastian membutuhkan strategi adaptif.",
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

  /// 🔥 OPTION UI
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
              ? Colors.purple.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 12,
              )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.circle,
                color: isSelected ? Colors.purple : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice["text"],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.purple
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