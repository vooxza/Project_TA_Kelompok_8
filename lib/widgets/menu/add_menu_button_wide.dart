import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Tombol "Tambah Menu" untuk header MenuPage versi wide (khusus Admin).
/// Gaya pill (ikon + teks) mengikuti desain lib11, tapi dibuat lebih lebar
/// & dominan karena tombol profil di kanan atas sudah dihilangkan —
/// ruang yang tersisa dipakai supaya tombol ini lebih mudah diakses.
class AddMenuButtonWide extends StatelessWidget {
  final VoidCallback onTap;
  const AddMenuButtonWide({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 22, color: AppColors.textWhite),
            SizedBox(width: 10),
            Text(
              'Tambah Menu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
