import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/menu_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/menu/category_chips.dart';
import '../../widgets/menu/menu_empty.dart';
import '../../widgets/menu/menu_grid.dart';
import '../../widgets/menu/menu_header.dart';
import '../../widgets/menu/menu_search.dart';

/// Versi mobile dari MenuPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `menu_page.dart` cuma jadi switcher tipis.
class MenuPageMobile extends GetView<MenuController> {
  const MenuPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgCream,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const MenuHeader(),
              const SizedBox(height: 16),
              const MenuSearch(),
              const SizedBox(height: 14),
              const CategoryChips(),

              const SizedBox(height: 8),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                        strokeWidth: 2.5,
                      ),
                    );
                  }

                  final filteredMenu = controller.filteredMenu;

                  if (filteredMenu.isEmpty) {
                    return const MenuEmpty();
                  }

                  return MenuGrid(
                    items: filteredMenu,
                    cartController: cartController,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
