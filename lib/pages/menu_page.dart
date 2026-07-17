import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/menu_controller.dart';
import '../core/responsive/responsive_layout.dart';
import '../core/theme/app_colors.dart';
import '../widgets/menu/category_chips.dart';
import '../widgets/menu/menu_empty.dart';
import '../widgets/menu/menu_grid.dart';
import '../widgets/menu/menu_header.dart';
import '../widgets/menu/menu_search.dart';
import 'wide/menu_page_wide.dart';

class MenuPage extends GetView<MenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _MenuPageMobile(),
      wide: MenuPageWide(),
    );
  }
}

class _MenuPageMobile extends GetView<MenuController> {
  const _MenuPageMobile();

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