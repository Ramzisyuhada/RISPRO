import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

class RisproProgressJourney extends StatelessWidget {
  final int currentStep; // 1-indexed (1 to totalSteps)
  final int totalSteps;
  final String stageName;
  final String? subtitle;

  const RisproProgressJourney({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    required this.stageName,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RisproColors.border, width: 1),
        boxShadow: RisproColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: RisproColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$currentStep",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: RisproColors.textMain,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: RisproColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: RisproColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Tahap $currentStep/$totalSteps",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: RisproColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Journey Step Nodes Bar
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background track
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: RisproColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // Filled track
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [RisproColors.primary, RisproColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              // Stage Checkpoint Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (index) {
                  final isReached = index + 1 <= currentStep;
                  final isCurrent = index + 1 == currentStep;

                  return Container(
                    width: isCurrent ? 13 : 9,
                    height: isCurrent ? 13 : 9,
                    decoration: BoxDecoration(
                      color: isReached ? RisproColors.primary : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isReached ? RisproColors.accent : RisproColors.border,
                        width: isCurrent ? 2.5 : 1.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: RisproColors.accent.withValues(alpha: 0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
