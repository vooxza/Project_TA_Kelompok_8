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
                        child: _SearchBox(controller: controller),
                      ),
                      const SizedBox(width: 16),
                      if (RoleService.isAdmin)
                        _HeaderButton(
                          icon: Icons.add_rounded,
                          color: AppColors.primaryRed,
                          onTap: () => Get.toNamed(AppRoutes.addMenu),
                        ),
                      if (RoleService.isAdmin) const SizedBox(width: 10),
                      _HeaderButton(
                        icon: Icons.person_outline_rounded,
                        color: AppColors.bgSurface,
                        iconColor: AppColors.textDark,
                        onTap: () => Get.toNamed(AppRoutes.profile),
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

                    return LayoutBuilder(builder: (context, constraints) {
                      // Sesuaikan jumlah kolom dengan lebar konten
                      final cols = constraints.maxWidth >= 1000
                          ? 4
                          : constraints.maxWidth >= 750
                              ? 3
                              : 2;
                      return MenuGrid(
                        items: filteredMenu,
                        cartController: cartController,
                        crossAxisCount: cols,
                        childAspectRatio: 0.82,
                        padding: const EdgeInsets.fromLTRB(28, 4, 28, 28),
                      );
                    });
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

class _SearchBox extends StatelessWidget {
  final MenuController controller;
  const _SearchBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) => controller.searchQuery.value = value,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: false,
          prefixIcon: Icon(Icons.search_rounded,
              color: AppColors.textLight, size: 20),
          hintText: 'Cari menu favorit kamu...',
          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.color,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 22, color: iconColor ?? AppColors.textWhite),
      ),
    );
  }
}
