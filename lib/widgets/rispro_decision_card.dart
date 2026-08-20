import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

class RisproDecisionCard extends StatefulWidget {
  final String text;
  final String? subtitle;
  final Map<String, dynamic>? impact;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final bool isDisabled;
  final VoidCallback? onTap;
  final int index;

  const RisproDecisionCard({
    super.key,
    required this.text,
    this.subtitle,
    this.impact,
    this.isSelected = false,
    this.isCorrect = false,
    this.isIncorrect = false,
    this.isDisabled = false,
    this.onTap,
    this.index = 0,
  });

  @override
  State<RisproDecisionCard> createState() => _RisproDecisionCardState();
}

class _RisproDecisionCardState extends State<RisproDecisionCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color borderColor = RisproColors.border;
    Color textColor = RisproColors.textMain;
    Color iconColor = RisproColors.secondary;
    Widget stateIcon;

    if (widget.isCorrect) {
      bg = RisproColors.successBg;
      borderColor = RisproColors.success;
      textColor = const Color(0xFF0E5343);
      iconColor = RisproColors.success;
      stateIcon = const Icon(Icons.check_circle_rounded, color: RisproColors.success, size: 24);
    } else if (widget.isIncorrect) {
      bg = RisproColors.dangerBg;
      borderColor = RisproColors.danger;
      textColor = const Color(0xFF8C1D1D);
      iconColor = RisproColors.danger;
      stateIcon = const Icon(Icons.cancel_rounded, color: RisproColors.danger, size: 24);
    } else if (widget.isSelected) {
      bg = RisproColors.surfaceSubtle;
      borderColor = RisproColors.primary;
      textColor = RisproColors.primary;
      iconColor = RisproColors.primary;
      stateIcon = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: RisproColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else if (_isHovered) {
      bg = const Color(0xFFFAFDFA);
      borderColor = RisproColors.secondary;
      stateIcon = Icon(Icons.radio_button_unchecked_rounded, color: RisproColors.secondary, size: 24);
    } else {
      bg = Colors.white;
      borderColor = RisproColors.border;
      stateIcon = Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey.shade400, size: 24);
    }

    final scale = _isPressed ? 0.985 : (_isHovered && !widget.isDisabled ? 1.015 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isDisabled ? null : widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: widget.isSelected || widget.isCorrect || widget.isIncorrect ? 2.0 : 1.2,
              ),
              boxShadow: [
                if (widget.isSelected)
                  BoxShadow(
                    color: RisproColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                else if (_isHovered)
                  BoxShadow(
                    color: RisproColors.secondary.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                else
                  ...RisproColors.cardShadow,
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: stateIcon,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: textColor,
                          height: 1.45,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: RisproColors.textSecondary,
                          ),
                        ),
                      ],
                      if (widget.impact != null && widget.impact!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (widget.impact!["cost"] != null)
                              _impactPill("Biaya", widget.impact!["cost"], Colors.red.shade700),
                            if (widget.impact!["time"] != null)
                              _impactPill("Waktu", widget.impact!["time"], Colors.orange.shade800),
                            if (widget.impact!["risk"] != null)
                              _impactPill("Risiko", widget.impact!["risk"], RisproColors.primary),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: iconColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _impactPill(String label, dynamic value, Color color) {
    final intVal = value is num ? value.toInt() : int.tryParse(value.toString()) ?? 0;
    final sign = intVal > 0 ? "+$intVal%" : "$intVal%";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "$label: $sign",
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
