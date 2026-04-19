import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../widgets/index.dart';
import '../controllers/homepage_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.put(HomePageController());

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Column(
        children: [
          // Header Component
          const HomeHeader(),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Category Section Component
                  Obx(
                    () => CategorySection(
                      selectedCategory: controller.selectedCategory.value,
                      onCategorySelected: (category) {
                        controller.selectCategory(category);
                      },
                    ),
                  ),

                  // Menu Grid Component - already has Obx internally
                  const MenuGrid(),

                  const SizedBox(height: 30),
                ],  
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
