import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

/// RISPRO Original Brand Logo Icon & Lockup
/// Concept: Geometric 'R' + Decision Node Network + Risk Pathway Shield
class RisproLogoIcon extends StatelessWidget {
  final double size;
  final bool isDark;

  const RisproLogoIcon({
    super.key,
    this.size = 40,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1B4E47), const Color(0xFF123B35)]
              : [RisproColors.primary, RisproColors.secondary],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: RisproColors.primary.withValues(alpha: 0.22),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _RisproIconPainter(),
      ),
    );
  }
}

class _RisproIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintLine = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintAccent = Paint()
      ..color = RisproColors.accent
      ..style = PaintingStyle.fill;

    final paintNode = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 1. Vertical Spine of 'R'
    final spinePath = Path()
      ..moveTo(w * 0.30, h * 0.22)
      ..lineTo(w * 0.30, h * 0.78);
    canvas.drawPath(spinePath, paintLine);

    // 2. Upper Loop of 'R' (Branching Pathway)
    final loopPath = Path()
      ..moveTo(w * 0.30, h * 0.24)
      ..cubicTo(
        w * 0.78, h * 0.22,
        w * 0.78, h * 0.50,
        w * 0.30, h * 0.50,
      );
    canvas.drawPath(loopPath, paintLine);

    // 3. Diagonal Leg of 'R' (Decision Path)
    final legPath = Path()
      ..moveTo(w * 0.44, h * 0.50)
      ..lineTo(w * 0.74, h * 0.78);
    canvas.drawPath(legPath, paintLine);

    // 4. Decision Nodes (Glowing Amber & White Network Dots)
    canvas.drawCircle(Offset(w * 0.74, h * 0.78), w * 0.08, paintAccent);
    canvas.drawCircle(Offset(w * 0.30, h * 0.22), w * 0.065, paintNode);
    canvas.drawCircle(Offset(w * 0.68, h * 0.36), w * 0.06, paintAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Full RISPRO Logo Lockup: [ICON] RISPRO | Risk Decision Simulator
class RisproLogoLockup extends StatelessWidget {
  final double iconSize;
  final bool showSubtitle;
  final bool isDarkText;
  final String? subtitleText;

  const RisproLogoLockup({
    super.key,
    this.iconSize = 36,
    this.showSubtitle = true,
    this.isDarkText = true,
    this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkText ? RisproColors.textMain : Colors.white;
    final subtitleColor = isDarkText ? RisproColors.textSecondary : Colors.white70;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RisproLogoIcon(size: iconSize),
        SizedBox(width: iconSize * 0.30),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      "RISPRO",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: iconSize * 0.54,
                        color: titleColor,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: RisproColors.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "SIM",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: iconSize * 0.25,
                        color: isDarkText ? RisproColors.accentDark : RisproColors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              if (showSubtitle) ...[
                const SizedBox(height: 2),
                Text(
                  subtitleText ?? "Risk Decision Simulator",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: iconSize * 0.28,
                    color: subtitleColor,
                    letterSpacing: 0.1,
                    height: 1.1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
