import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bottomnav_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

/// Drawer navigasi untuk layar lebar (tablet/desktop), pengganti
/// [BottomNavBar] versi mobile. Selalu tampil di sisi kiri (persistent),
/// dan pakai [BottomNavController] yang sama supaya state tab yang aktif
/// tetap sinkron dengan versi mobile.
class WideNavDrawer extends StatelessWidget {
  const WideNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();
    final cartController = Get.find<CartController>();

    return Container(
      width: 220,
      height: double.infinity,
      color: AppColors.bgWhite,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / brand
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.restaurant_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Mbok Kerso',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Badge role, biar jelas lagi login sebagai siapa (berguna
            // banget kalau ganti akun admin <-> kasir di device yang sama).
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: RoleService.isAdmin
                        ? AppColors.primaryRed.withOpacity(0.1)
                        : AppColors.accentGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    RoleService.isAdmin ? 'ADMIN' : 'KASIR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: RoleService.isAdmin
                          ? AppColors.primaryRed
                          : const Color(0xFF8A6D1D),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _NavTile(
                    label: 'Menu',
                    icon: Icons.menu_book_rounded,
                    index: 0,
                    controller: controller,
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => _NavTile(
                      label: 'Keranjang',
                      icon: Icons.shopping_cart_rounded,
                      index: 1,
                      controller: controller,
                      badgeCount: cartController.cartItems.length,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _NavTile(
                    label: 'Riwayat',
                    icon: Icons.receipt_long_rounded,
                    index: 2,
                    controller: controller,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _NavTile(
                label: 'Profil',
                icon: Icons.person_outline_rounded,
                index: -1,
                controller: controller,
                onTap: () => Get.toNamed(AppRoutes.profile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final int index;
  final BottomNavController controller;
  final VoidCallback? onTap;
  final int badgeCount;

  const _NavTile({
    required this.label,
    required this.icon,
    required this.index,
    required this.controller,
    this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Selalu baca Rx terlebih dahulu
      final currentIndex = controller.currentIndex.value;

      final isSelected = index >= 0 && currentIndex == index;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap ?? () => controller.goTo(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryRed.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primaryRed
                      : AppColors.textLight,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.textMedium,
                    ),
                  ),
                ),
                if (badgeCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.primaryRed.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
