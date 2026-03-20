import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rispro/data/vendor_data.dart';

class Scene2Screen extends StatefulWidget {

  final VendorData vendor;
  const Scene2Screen({super.key,required this.vendor});

  @override
  State<Scene2Screen> createState() => _Scene2ScreenState();
}

class _Scene2ScreenState extends State<Scene2Screen> {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color textPrimary = Color(0xFF0F172A);
  /// 🔥 LIST BISA BERUBAH
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

      /// 🔥 HILANGKAN DARI ATAS
      risks.removeWhere((r) => r["text"] == data["text"]);

      if (isCorrect) correct++;
    });

    /// AUTO NEXT
    if (resultMap.length == 5) {
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushNamed(context, '/scene3', arguments: widget.vendor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [

            /// 🔹 HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Klasifikasi Risiko",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Drag risiko ke kategori yang sesuai",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: resultMap.length / 5,
                    color: primary,
                    backgroundColor: primary.withOpacity(0.1),
                  )
                ],
              ),
            ),

            /// 🔹 DRAG AREA
            SizedBox(
              height: 110,
              child: risks.isEmpty
                  ? const Center(
                      child: Text(
                        "Semua sudah diklasifikasi 🎉",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: risks.map((r) {
                          return Draggable<Map<String, String>>(
                            data: r,

                            /// 🔥 FEEDBACK JELAS
                            feedback: Material(
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 1.1,
                                child: _dragItem(
                                  r["text"]!,
                                  dragging: true,
                                ),
                              ),
                            ),

                            childWhenDragging: const SizedBox(),

                            child: _dragItem(r["text"]!),
                          );
                        }).toList(),
                      ),
                    ),
            ),

            const SizedBox(height: 10),

            /// 🔻 DROP ZONE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  children: [
                    _dropZone("Certainty", "certainty", Colors.blue),
                    _dropZone("Risk", "risk", Colors.orange),
                    _dropZone("Uncertainty", "uncertainty", Colors.red),
                  ],
                ),
              ),
            ),

            /// 🔹 SCORE
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Benar: $correct / 5",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),

            /// 🔹 BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/scene3',arguments: widget.vendor);
                },
                child: const Text("Lanjut"),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔹 DRAG ITEM
  Widget _dragItem(String text, {bool dragging = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: dragging ? primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: dragging ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    )
        .animate()
        .fade()
        .scale(begin: const Offset(0.9, 0.9));
  }

  /// 🔹 DROP ZONE
  Widget _dropZone(String title, String type, Color color) {
    return DragTarget<Map<String, String>>(
      onAccept: (data) => handleDrop(data, type),
      builder: (context, candidate, rejected) {

        bool isHovering = candidate.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHovering
                ? color.withOpacity(0.25)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            children: [

              /// TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, color: color, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),

              const Divider(),

              /// CONTENT
              Expanded(
                child: dropped[type]!.isEmpty
                    ? const Center(
                        child: Text(
                          "Drop di sini",
                          style: TextStyle(color: Colors.black38),
                        ),
                      )
                    : ListView(
                        children: dropped[type]!.map((e) {
                          bool? isCorrect = resultMap[e];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isCorrect == true
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrect == true
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  size: 16,
                                  color: isCorrect == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .scale(begin: const Offset(0.8, 0.8))
                              .fade();
                        }).toList(),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}