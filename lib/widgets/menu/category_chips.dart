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
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedId == category.id; 

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.selectedCategoryId.value = category.id;
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryRed
                      : AppColors.textWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryRed),
                ),
                child: Center(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
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