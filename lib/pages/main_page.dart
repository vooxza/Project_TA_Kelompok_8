import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../pages/home_page.dart';
import '../pages/menu_page.dart';
import '../pages/cart_page.dart';
import '../widgets/bottom_nav_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();

    return Obx(() => Scaffold(
      body: IndexedStack(
        index: navController.currentIndex.value,
        children: const [
          HomePage(),
          MenuPage(),
          CartPage(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    ));
  }
}