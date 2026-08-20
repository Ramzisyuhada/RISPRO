import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/vendor_data.dart';
import '../theme/rispro_colors.dart';

class VendorCard extends StatelessWidget {
  final VoidCallback onTap;
  final VendorData? vendor;

  const VendorCard({
    super.key,
    required this.onTap,
    this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    if (vendor == null) return const SizedBox();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: RisproColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: RisproColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Vendor Image / Avatar
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: RisproColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RisproColors.border, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  vendor!.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.business_rounded,
                    color: RisproColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Vendor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor!.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: RisproColors.textMain,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: RisproColors.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Vendor",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: RisproColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: RisproColors.accent, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            vendor!.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: RisproColors.textMain,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: RisproColors.secondary, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            "${vendor!.projects} proyek",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: RisproColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.task_alt_rounded, color: RisproColors.success, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            "${vendor!.successRate}%",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: RisproColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "Tap untuk melihat profil lengkap →",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: RisproColors.accentDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}