import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

class RisproCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? accentColor;
  final Color? backgroundColor;
  final double borderRadius;
  final bool hasBorder;
  final bool showAccentBar;
  final double? width;
  final double? height;

  const RisproCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.accentColor,
    this.backgroundColor,
    this.borderRadius = 22,
    this.hasBorder = true,
    this.showAccentBar = false,
    this.width,
    this.height,
  });

  @override
  State<RisproCard> createState() => _RisproCardState();
}

class _RisproCardState extends State<RisproCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = widget.backgroundColor ?? RisproColors.surface;
    final isInteractive = widget.onTap != null;

    final cardContent = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.hasBorder
            ? Border.all(
                color: _isHovered && widget.accentColor != null
                    ? widget.accentColor!.withValues(alpha: 0.5)
                    : RisproColors.border,
                width: _isHovered ? 1.5 : 1.0,
              )
            : null,
        boxShadow: _isHovered && isInteractive
            ? [
                BoxShadow(
                  color: (widget.accentColor ?? RisproColors.primary).withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : RisproColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            if (widget.showAccentBar && widget.accentColor != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 4,
                child: Container(
                  color: widget.accentColor,
                ),
              ),
            Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ],
        ),
      ),
    );

    if (!isInteractive) return cardContent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: cardContent,
        ),
      ),
    );
  }
}

/// Feature Card for Home Screen (Materi, Kuis, Tentang)
class RisproFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? tag;
  final Color accentColor;
  final VoidCallback onTap;

  const RisproFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.tag,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RisproCard(
      onTap: onTap,
      accentColor: accentColor,
      padding: const EdgeInsets.all(18),
      borderRadius: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            child: Icon(icon, size: 24, color: accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: RisproColors.textMain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: accentColor,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: RisproColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
