import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Header halaman Keranjang versi wide: judul "Keranjang" + badge jumlah
/// item (hanya tampil kalau keranjang tidak kosong).
class CartHeaderWide extends StatelessWidget {
  final int itemCount;
  const CartHeaderWide({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Keranjang',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 12),
        if (itemCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$itemCount item',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
          ),
      ],
    );
  }
}
