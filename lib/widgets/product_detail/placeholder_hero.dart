import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Placeholder gambar produk kalau URL gambar kosong/gagal dimuat.
/// Dipakai bareng oleh versi mobile & wide Product Detail.
class PlaceholderHero extends StatelessWidget {
  const PlaceholderHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: const Center(
        child: Icon(
          Icons.ramen_dining_rounded,
          size: 80,
          color: AppColors.borderMedium,
        ),
      ),
    );
  }
}
