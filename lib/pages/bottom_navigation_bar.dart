import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../pages/homepage.dart';
import '../pages/menu_page.dart';
import '../pages/keranjang_page.dart';


class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key, required this.currentIndex});
  final int currentIndex;
  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    controller.changeTab(currentIndex);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(40),
      ),

      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            navItem("BERANDA", 0),
            navItem("MENU", 1),
            navItem("KERANJANG", 2),
          ],
        ),
      ),
    );
  }

  Widget navItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
        if (index == 0) {
          Get.offAll(() => const HomePage());
        } else if (index == 1) {
          Get.offAll(() => const MenuPage());
        } else if (index == 2) {
          Get.offAll(() => const CartPage());
        }
      },
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: controller.currentIndex.value == index
              ? const Color(0xFFB71C1C) // AKTIF
              : Colors.black54, // TIDAK AKTIF
        ),
      ),
    );
  }
}
