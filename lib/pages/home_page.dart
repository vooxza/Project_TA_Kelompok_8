import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan ini untuk mengatur warna icon status bar
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../widgets/index.dart';
import '../controllers/homepage_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePageController controller = Get.find<HomePageController>();

   
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.bgGrey,
        body: Column(
          children: [
            // Header tetap di atas
            const HomeHeader(),
            const PaketCarousel(),

                    // Category Section
                    Obx(
                      () => CategorySection(
                        selectedCategory: controller.selectedCategory.value,
                        onCategorySelected: controller.selectCategory,
                      ),
                    ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MenuGrid(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}