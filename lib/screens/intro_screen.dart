import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/domain/service/simulation_ai_service.dart';
import '../widgets/vendor_card.dart';
import '../data/vendor_data.dart';

class SimulationIntroScreen extends StatefulWidget {
  const SimulationIntroScreen({super.key});

  @override
  State<SimulationIntroScreen> createState() =>
      _SimulationIntroScreenState();
}

class _SimulationIntroScreenState extends State<SimulationIntroScreen> {
  int step = 0;
  String displayedText = "";

  VendorData? vendor;
  final aiService = SimulationAIService();

  final List<Map<String, String>> scenes = [
    {
      "text":
          "Anda ditunjuk sebagai Project Manager proyek layanan publik digital.",
      "char": "assets/AssetGame/player_normal.png"
    },
    {
      "text":
          "Proyek ini melibatkan banyak stakeholder dan risiko.",
      "char": "assets/AssetGame/player_thinking.png"
    },
    {
      "text":
          "Keputusan Anda akan mempengaruhi keberhasilan proyek.",
      "char": "assets/AssetGame/player_woried.png"
    },
    {
      "text":
          "Apakah Anda siap mengambil keputusan?",
      "char": "assets/AssetGame/player_confident.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTyping();
    loadVendor(); // 🔥 ambil vendor dari AI
  }

  /// 🔥 LOAD VENDOR AI
  void loadVendor() async {
    final data = await aiService.generateVendor();
    print(data.toString());
    setState(() {
      vendor = data;
    });
  }

  /// 🔥 TYPEWRITER EFFECT
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

  /// 🔥 NEXT SCENE
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
}    }
  }

  /// 🔥 MODAL DETAIL VENDOR
  void showVendorDetail() {
    if (vendor == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black),
            child: Column(
              children: [
                const Text(
                  "Vendor Profile",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Image.asset(vendor!.image, height: 120),

                const SizedBox(height: 16),

                Text(
                  vendor!.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(vendor!.rating.toString()),

                    const SizedBox(width: 16),

                    const Icon(Icons.inventory_2, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text("${vendor!.projects} proyek"),

                    const SizedBox(width: 16),

                    const Icon(Icons.schedule, color: Colors.green),
                    const SizedBox(width: 4),
                    Text("${vendor!.successRate}%"),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  vendor!.description,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ).animate().slideY(begin: 1, duration: 400.ms);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scene = scenes[step];

    return Scaffold(
      body: GestureDetector(
        onTap: nextStep,
        child: Stack(
          children: [
            /// BACKGROUND
            Positioned.fill(
              child: Image.asset(
                'assets/AssetGame/Background Game.png',
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.05),
              ),
            ),

            /// 🔥 VENDOR CARD
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: vendor == null
                  ? const Center(child: CircularProgressIndicator())
                  : VendorCard(
                      vendor: vendor!,
                      onTap: showVendorDetail,
                    ),
            ),

            /// PLAYER
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                scene["char"]!,
                height: 260,
              ),
            ),

            /// DIALOG
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.black),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(displayedText,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      const Text(
                        "Tap untuk lanjut...",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
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