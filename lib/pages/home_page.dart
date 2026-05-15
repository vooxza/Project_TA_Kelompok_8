import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — tetap di atas
            const HomeHeader(),

            // Paket Carousel — tetap di atas
            const PaketCarousel(),
            // Category Section — tetap di atas
            Obx(
              () => CategorySection(
                selectedCategory: controller.selectedCategory.value,
                onCategorySelected: controller.selectCategory,
              ),
            ),

            SizedBox(height: 30),
            // Menu Grid — hanya bagian ini yang scroll
            Expanded(
              child: Obx(() => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        MenuGrid(
                          selectedCategoryName:
                              controller.selectedCategory.value,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}