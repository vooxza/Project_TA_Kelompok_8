import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../routes/routes.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/menu_card.dart';
import '../widgets/category_chips.dart';

class MenuPage extends GetView<MenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textWhite),
            onPressed: () => Get.toNamed(AppRoutes.addMenu),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 10),

            /// CATEGORY
            CategoryChips(),

            const SizedBox(height: 10),

            /// GRID MENU
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: controller.filteredMenu.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredMenu[index];
                  return MenuCard(
                    item: item,
                    cartController: cartController,
                  );
                },
              ),
            ),
          ],
        );
      }),

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}