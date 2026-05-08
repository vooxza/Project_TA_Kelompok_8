import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/menu/menu_card.dart';
import '../widgets/menu/category_chips.dart';
import '../core/services/role_service.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = Get.find<MenuController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          // ✅ Hanya admin yang bisa lihat tombol tambah
          if (RoleService.isAdmin)
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.textWhite),
              onPressed: () => Get.toNamed(AppRoutes.addMenu),
            ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          const CategoryChips(),

          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              final selectedId = menuController.selectedCategoryId.value;
              final filteredMenu = menuController.filteredMenu;

              if (menuController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (filteredMenu.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada menu tersedia',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: filteredMenu.length,
                itemBuilder: (context, index) {
                  final item = filteredMenu[index];
                  return MenuCard(
                    item: item,
                    cartController: cartController,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}