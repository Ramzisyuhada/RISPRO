import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

enum RisproDecisionStateType {
  certainty,
  risk,
  uncertainty,
  neutral,
}

class RisproDecisionStateBadge extends StatelessWidget {
  final RisproDecisionStateType stateType;
  final String? customLabel;
  final bool isLarge;

  const RisproDecisionStateBadge({
    super.key,
    required this.stateType,
    this.customLabel,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String defaultLabel;

    switch (stateType) {
      case RisproDecisionStateType.certainty:
        bg = RisproColors.certaintyBg;
        border = RisproColors.certainty.withValues(alpha: 0.4);
        text = RisproColors.certainty;
        icon = Icons.verified_user_rounded;
        defaultLabel = "Certainty (Pasti)";
        break;

      case RisproDecisionStateType.risk:
        bg = RisproColors.riskBg;
        border = RisproColors.risk.withValues(alpha: 0.4);
        text = RisproColors.risk;
        icon = Icons.warning_amber_rounded;
        defaultLabel = "Risk (Konsekuensi)";
        break;

      case RisproDecisionStateType.uncertainty:
        bg = RisproColors.uncertaintyBg;
        border = RisproColors.uncertainty.withValues(alpha: 0.4);
        text = RisproColors.uncertainty;
        icon = Icons.help_outline_rounded;
        defaultLabel = "Uncertainty (Ketidakpastian)";
        break;

      case RisproDecisionStateType.neutral:
        bg = RisproColors.surfaceSubtle;
        border = RisproColors.border;
        text = RisproColors.primary;
        icon = Icons.info_outline_rounded;
        defaultLabel = "Decision Stage";
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 14 : 10,
        vertical: isLarge ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isLarge ? 18 : 14, color: text),
          const SizedBox(width: 6),
          Text(
            customLabel ?? defaultLabel,
            style: GoogleFonts.poppins(
              fontSize: isLarge ? 13 : 11,
              fontWeight: FontWeight.w700,
              color: text,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class RisproTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color? backgroundColor;

  const RisproTag({
    super.key,
    required this.label,
    this.icon,
    this.color = RisproColors.primary,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
