import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.bgGreyLight,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
  label: "HOME",
  index: 0,
  controller: controller,
  icon: Icons.home,
),
_buildNavItem(
  label: "MENU",
  index: 1,
  controller: controller,
  icon: Icons.menu,
),
_buildNavItem(
  label: "CART",
  index: 2,
  controller: controller,
  icon: Icons.shopping_cart,
),
        ],
      ),
    );
  }

  Widget _buildNavItem({
  required String label,
  required int index,
  required BottomNavController controller,
  required IconData icon,
}) {
  return Obx(
    () => GestureDetector(
      onTap: () => controller.goTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: controller.currentIndex.value == index
              ? AppColors.textWhite
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: controller.currentIndex.value == index
                  ? AppColors.primaryRed
                  : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: controller.currentIndex.value == index
                    ? AppColors.primaryRed
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}