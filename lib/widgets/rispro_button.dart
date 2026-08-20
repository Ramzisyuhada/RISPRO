import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';

enum RisproButtonVariant {
  primaryCta,
  secondary,
  outline,
  accent,
  ghost,
}

class RisproButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isTrailingIcon;
  final RisproButtonVariant variant;
  final double? width;
  final double height;
  final double fontSize;
  final bool isLoading;

  const RisproButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isTrailingIcon = false,
    this.variant = RisproButtonVariant.primaryCta,
    this.width,
    this.height = 58,
    this.fontSize = 18,
    this.isLoading = false,
  });

  @override
  State<RisproButton> createState() => _RisproButtonState();
}

class _RisproButtonState extends State<RisproButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Decoration decoration;
    Color textColor;
    Color iconColor;

    switch (widget.variant) {
      case RisproButtonVariant.primaryCta:
        decoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEnabled
                ? (_isHovered
                    ? [const Color(0xFF164740), const Color(0xFF17927B)]
                    : [RisproColors.primary, RisproColors.secondary])
                : [Colors.grey.shade400, Colors.grey.shade500],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: RisproColors.primary.withValues(alpha: _isHovered ? 0.35 : 0.22),
                    blurRadius: _isHovered ? 20 : 12,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                  BoxShadow(
                    color: RisproColors.accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
          border: Border.all(
            color: RisproColors.accent.withValues(alpha: isEnabled ? 0.35 : 0.0),
            width: 1.2,
          ),
        );
        textColor = Colors.white;
        iconColor = RisproColors.accent;
        break;

      case RisproButtonVariant.accent:
        decoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEnabled
                ? (_isHovered
                    ? [const Color(0xFFFBA844), const Color(0xFFDE831D)]
                    : [RisproColors.accent, RisproColors.accentDark])
                : [Colors.grey.shade400, Colors.grey.shade500],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: RisproColors.accent.withValues(alpha: _isHovered ? 0.4 : 0.25),
                    blurRadius: _isHovered ? 18 : 10,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                ]
              : [],
        );
        textColor = RisproColors.primaryDark;
        iconColor = RisproColors.primaryDark;
        break;

      case RisproButtonVariant.secondary:
        decoration = BoxDecoration(
          color: isEnabled
              ? (_isHovered ? RisproColors.surfaceSubtle : Colors.white)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isEnabled ? RisproColors.border : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isEnabled ? RisproColors.cardShadow : [],
        );
        textColor = isEnabled ? RisproColors.textMain : Colors.grey.shade500;
        iconColor = isEnabled ? RisproColors.primary : Colors.grey.shade500;
        break;

      case RisproButtonVariant.outline:
        decoration = BoxDecoration(
          color: _isHovered ? RisproColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isEnabled ? RisproColors.primary : Colors.grey.shade400,
            width: 2,
          ),
        );
        textColor = isEnabled ? RisproColors.primary : Colors.grey.shade400;
        iconColor = isEnabled ? RisproColors.primary : Colors.grey.shade400;
        break;

      case RisproButtonVariant.ghost:
        decoration = BoxDecoration(
          color: _isHovered ? RisproColors.surfaceSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        );
        textColor = isEnabled ? RisproColors.textSecondary : Colors.grey.shade400;
        iconColor = isEnabled ? RisproColors.textSecondary : Colors.grey.shade400;
        break;
    }

    final double scale = _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: isEnabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: decoration,
            child: widget.isLoading
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      if (widget.icon != null && !widget.isTrailingIcon) ...[
                        Icon(widget.icon, size: widget.fontSize + 2, color: iconColor),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (widget.icon != null && widget.isTrailingIcon) ...[
                        const SizedBox(width: 10),
                        Icon(widget.icon, size: widget.fontSize + 2, color: iconColor),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
