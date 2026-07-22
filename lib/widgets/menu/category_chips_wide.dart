import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../controllers/menu_controller.dart';
import '../../core/theme/app_colors.dart';

/// Baris kategori (chip) horizontal untuk MenuPage versi wide.
/// Desain & perilaku sama seperti [CategoryChips] versi mobile, hanya
/// gaya chip disesuaikan supaya pas dengan header widescreen.
class CategoryChipsWide extends StatelessWidget {
  final MenuController controller;
  const CategoryChipsWide({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedId = controller.selectedCategoryId.value;
      final categories = controller.categories;
      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            final bool isAll = index == 0;
            final int? categoryId = isAll ? null : categories[index - 1].id;
            final String categoryName =
                isAll ? 'Semua' : categories[index - 1].name;
            final isSelected = selectedId == categoryId;

            return GestureDetector(
              onTap: () => controller.selectedCategoryId.value = categoryId,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryRed
                      : AppColors.bgSurfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.borderLight,
                  ),
                ),
                child: Center(
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
