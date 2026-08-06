import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';
import '../core/responsive/responsive_layout.dart';
import '../core/theme/app_colors.dart';
import '../pages/menu_page.dart';
import '../pages/cart_page.dart';
import '../pages/history_page.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import '../widgets/navigation/wide_nav_drawer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();

    return Obx(() {
      final body = IndexedStack(
        index: navController.currentIndex.value,
        children: const [
          MenuPage(),
          CartPage(),
          HistoryPage(),
        ],
      );

      return ResponsiveLayout(
        mobile: Scaffold(
          body: body,
          bottomNavigationBar: const BottomNavBar(),
        ),
        wide: Scaffold(
          backgroundColor: AppColors.bgGrey,
          body: Row(
            children: [
              const WideNavDrawer(),
              Expanded(child: body),
            ],
          ),
        ),
      );
    });
  }
}
