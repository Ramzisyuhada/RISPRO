import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {

  static const Color primary = Color(0xFF1E3A8A);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  late VideoPlayerController _videoController;

  final List<String> slides = [
    'assets/ppt/1.png',
    'assets/ppt/2.png',
    'assets/ppt/3.png',
  ];

  int currentSlide = 0;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/video/Video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Materi",
          style: TextStyle(color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 📘 INTRO
            _sectionTitle("Pengantar"),
            _card(
              "Manajemen risiko membantu pengambilan keputusan dalam kondisi certainty, risk, dan uncertainty.",
            ).animate().fade(),

            const SizedBox(height: 20),

            /// 📊 PPT (IMAGE SLIDER)
            _sectionTitle("Materi PPT"),
            _pptViewer().animate().fade(delay: 200.ms),

            const SizedBox(height: 20),

            /// 🎥 VIDEO INTERNAL
            _sectionTitle("Video Pembelajaran"),
            _videoPlayer().animate().fade(delay: 300.ms),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔹 TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }

  /// 🔹 TEXT CARD
  Widget _card(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: textSecondary),
      ),
    );
  }

  /// 📊 PPT VIEWER (IMAGE BASED)
  Widget _pptViewer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              slides[currentSlide],
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          /// SLIDER CONTROL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: currentSlide > 0
                    ? () {
                        setState(() {
                          currentSlide--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                "${currentSlide + 1}/${slides.length}",
                style: const TextStyle(color: textSecondary),
              ),
              IconButton(
                onPressed: currentSlide < slides.length - 1
                    ? () {
                        setState(() {
                          currentSlide++;
                        });
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🎥 VIDEO PLAYER INTERNAL
  Widget _videoPlayer() {
    if (!_videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VideoPlayer(_videoController),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: primary,
              ),
              onPressed: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
              },
            )
          ],
        )
      ],
    );
  }
}