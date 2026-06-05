import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/menu_controller.dart' as custom;

class CategoryChips extends GetView<custom.MenuController> {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedId = controller.selectedCategoryId.value;
      final categories = controller.categories;

      return SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length + 1, // +1 untuk "Semua"
          itemBuilder: (context, index) {
            final bool isAll = index == 0;

            final int? categoryId = isAll
                ? null
                : categories[index - 1].id;

            final String categoryName = isAll
                ? 'Semua'
                : categories[index - 1].name;

            final isSelected = selectedId == categoryId;

            return GestureDetector(
              onTap: () =>
                  controller.selectedCategoryId.value = categoryId,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 18),
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
                      fontSize: 13,
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