import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MenuEmpty extends StatelessWidget {
  const MenuEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Menu tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba kata kunci lain atau\npilih kategori berbeda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}