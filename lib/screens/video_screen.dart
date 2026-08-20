import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../theme/rispro_colors.dart';
import '../widgets/rispro_app_bar.dart';
import '../widgets/rispro_button.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoController;

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
      backgroundColor: RisproColors.background,
      appBar: const RisproAppBar(title: "Video Pembelajaran"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Video Frame Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                      boxShadow: RisproColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Player Area
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                          child: _videoController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _videoController.value.aspectRatio,
                                  child: VideoPlayer(_videoController),
                                )
                              : AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    color: RisproColors.primaryDark,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: RisproColors.accent,
                                      ),
                                    ),
                                  ),
                                ),
                        ),

                        // Controls
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              // Progress Bar
                              if (_videoController.value.isInitialized)
                                VideoProgressIndicator(
                                  _videoController,
                                  allowScrubbing: true,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  colors: VideoProgressColors(
                                    playedColor: RisproColors.secondary,
                                    bufferedColor: RisproColors.border,
                                    backgroundColor: RisproColors.surfaceSubtle,
                                  ),
                                ),

                              const SizedBox(height: 6),

                              // Time Labels
                              if (_videoController.value.isInitialized)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_videoController.value.position),
                                      style: GoogleFonts.poppins(
                                        color: RisproColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_videoController.value.duration),
                                      style: GoogleFonts.poppins(
                                        color: RisproColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 14),

                              // Play / Pause Action
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RisproButton(
                                    text: _videoController.value.isPlaying
                                        ? "Jeda Video"
                                        : "Putar Video",
                                    icon: _videoController.value.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    variant: _videoController.value.isPlaying
                                        ? RisproButtonVariant.secondary
                                        : RisproButtonVariant.primaryCta,
                                    height: 48,
                                    fontSize: 15,
                                    onPressed: () {
                                      setState(() {
                                        _videoController.value.isPlaying
                                            ? _videoController.pause()
                                            : _videoController.play();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade().scale(begin: const Offset(0.98, 0.98)),

                  const SizedBox(height: 20),

                  // Tips Callout
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: RisproColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: RisproColors.border, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_rounded,
                              color: RisproColors.accentDark,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Panduan Belajar",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: RisproColors.textMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Simak penjelasan mengenai perbedaan respon risiko proyek sektor publik. Perhatikan bagaimana keputusan pada Certainty berbeda dari situasi Uncertainty.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: RisproColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
