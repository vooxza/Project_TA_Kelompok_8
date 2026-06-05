import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(40),
        border: const Border.fromBorderSide(
          BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            label: 'Menu',
            index: 0,
            controller: controller,
            icon: Icons.menu_book_rounded,
          ),
          _buildNavItem(
            label: 'Cart',
            index: 1,
            controller: controller,
            icon: Icons.shopping_cart_rounded,
          ),
          _buildNavItem(
            label: 'History',
            index: 2,
            controller: controller,
            icon: Icons.receipt_long_rounded,
          ),
        ],
      ),
    );
  }
  }

  Widget _buildNavItem({
    required String label,
    required int index,
    required BottomNavController controller,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;

      return GestureDetector(
        onTap: () => controller.goTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 20 : 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primaryRed : AppColors.textLight,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }