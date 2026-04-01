import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../routes/routes.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            label: "BERANDA",
            index: 0,
            controller: controller,
            icon: Icons.home,
            onTap: () {
              controller.changeTab(0);
              Get.offNamed(AppRoutes.homepage);
            },
          ),
          _buildNavItem(
            label: "MENU",
            index: 1,
            controller: controller,
            icon: Icons.menu,
            onTap: () {
              controller.changeTab(1);
              Get.offNamed(AppRoutes.menu);
            },
          ),
          _buildNavItem(
            label: "KERANJANG",
            index: 2,
            controller: controller,
            icon: Icons.shopping_cart,
            onTap: () {
              controller.changeTab(2);
              // Navigate to cart page when available
            },
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
    required VoidCallback onTap,
  }) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: controller.currentIndex.value == index
                ? Colors.white
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
                    ? const Color(0xFFB71C1C)
                    : Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: controller.currentIndex.value == index
                      ? const Color(0xFFB71C1C)
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
