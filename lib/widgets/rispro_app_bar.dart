import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/rispro_colors.dart';
import 'rispro_logo.dart';

class RisproAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const RisproAppBar({
    super.key,
    this.title,
    this.showLogo = true,
    this.showBack = true,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: RisproColors.background,
          border: Border(
            bottom: BorderSide(color: RisproColors.borderSubtle, width: 1),
          ),
        ),
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RisproColors.border, width: 1),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: RisproColors.primary,
                    size: 20,
                  ),
                ),
                onPressed: onBack ?? () => Navigator.maybePop(context),
              )
            else if (showLogo)
              const RisproLogoLockup(iconSize: 32, showSubtitle: false),

            const SizedBox(width: 8),

            Expanded(
              child: title != null
                  ? Text(
                      title!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: RisproColors.textMain,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : (showBack && showLogo
                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: RisproLogoLockup(iconSize: 30, showSubtitle: false),
                        )
                      : const SizedBox()),
            ),

            ...?actions,
          ],
        ),
      ),
    );
  }
}
