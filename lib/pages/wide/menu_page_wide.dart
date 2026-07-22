import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/menu_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/menu/category_chips_wide.dart';
import '../../widgets/menu/menu_empty.dart';
import '../../widgets/menu/menu_grid.dart';
import '../../widgets/menu/menu_header_wide.dart';

/// Versi widescreen dari MenuPage. Struktur & data sama persis dengan
/// versi mobile, hanya reflow layout: header + search sejajar di atas,
/// kategori jadi chip horizontal, dan grid produk memakai lebih banyak
/// kolom (menyesuaikan lebar yang tersedia) supaya memanfaatkan lebar
/// layar. Memakai [WidePageContainer] supaya tampilannya satu kanvas
/// cream penuh, konsisten dengan halaman wide lainnya.
class MenuPageWide extends GetView<MenuController> {
  const MenuPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final box = GetStorage();
    final name = box.read('name') ?? 'User';
    final firstName = name.toString().split(' ').first;

    return WidePageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuHeaderWide(controller: controller, firstName: firstName),
          const SizedBox(height: 20),
          CategoryChipsWide(controller: controller),
          const SizedBox(height: 16),
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

              return LayoutBuilder(builder: (context, constraints) {
                final cols = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 650
                        ? 3
                        : 2;
                return MenuGrid(
                  items: filteredMenu,
                  cartController: cartController,
                  crossAxisCount: cols,
                  childAspectRatio: 0.74,
                  padding: const EdgeInsets.only(top: 4, bottom: 28),
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
