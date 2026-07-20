import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/menu_controller.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/menu/menu_empty.dart';
import '../../widgets/menu/menu_grid.dart';
import '../../widgets/menu/search_box_wide.dart';

/// Versi widescreen dari MenuPage (ditampilkan sebagai "Home" pada desain
/// Figma). Struktur & data sama persis dengan versi mobile, hanya reflow
/// layout: header + search sejajar di atas, kategori jadi chip horizontal,
/// dan grid produk memakai lebih banyak kolom supaya memanfaatkan lebar
/// layar.
class MenuPageWide extends GetView<MenuController> {
  const MenuPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final box = GetStorage();
    final name = box.read('name') ?? 'User';
    final firstName = name.toString().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgCream,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: greeting + search + actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 26, 28, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, $firstName!',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Mau Pesan Apa?',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Search box
                      Expanded(
                        flex: 2,
                        child: SearchBoxWide(controller: controller),
                      ),
                      const SizedBox(width: 16),
                      if (RoleService.isAdmin)
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.addMenu),
                          child: Container(
                            height: 48,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_rounded,
                                    size: 20, color: AppColors.textWhite),
                                SizedBox(width: 8),
                                Text(
                                  'Tambah Menu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Category chips
                Obx(() {
                  final selectedId = controller.selectedCategoryId.value;
                  final categories = controller.categories;
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        final bool isAll = index == 0;
                        final int? categoryId =
                            isAll ? null : categories[index - 1].id;
                        final String categoryName =
                            isAll ? 'Semua' : categories[index - 1].name;
                        final isSelected = selectedId == categoryId;

                        return GestureDetector(
                          onTap: () =>
                              controller.selectedCategoryId.value = categoryId,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : AppColors.bgSurfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryRed
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.textWhite
                                      : AppColors.textMedium,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Product grid
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
                      crossAxisCount: 4,
                      childAspectRatio: 0.72,
                      padding: const EdgeInsets.fromLTRB(28, 4, 28, 28),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
