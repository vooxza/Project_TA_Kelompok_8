import 'package:flutter/material.dart' hide MenuController;
import '../../controllers/menu_controller.dart';
import '../../core/theme/app_colors.dart';

/// Kotak pencarian menu untuk layar lebar. Dipisah dari
/// `pages/wide/menu_page_wide.dart` supaya tiap widget punya file sendiri.
class SearchBoxWide extends StatelessWidget {
  final MenuController controller;
  const SearchBoxWide({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) => controller.searchQuery.value = value,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: false,
          prefixIcon: Icon(Icons.search_rounded,
              color: AppColors.textLight, size: 20),
          hintText: 'Cari menu favorit kamu...',
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
