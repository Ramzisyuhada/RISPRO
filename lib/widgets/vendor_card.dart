import 'package:flutter/material.dart';
import '../data/vendor_data.dart';

class VendorCard extends StatelessWidget {
  final VoidCallback onTap;
  final VendorData? vendor;

  const VendorCard({
    super.key,
    required this.onTap,
    this.vendor, // tidak required
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),

        /// 🔥 PAKSA TEXT HITAM
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: Row(
            children: [

              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  vendor!.image,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    Text(
                      vendor!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          vendor!.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(width: 12),

                        const Icon(Icons.inventory_2,
                            color: Colors.blue, size: 18),
                        const SizedBox(width: 4),
                        Text("${vendor!.projects} proyek"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Tap untuk lihat profil",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}