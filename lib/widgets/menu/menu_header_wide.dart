import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../controllers/menu_controller.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import 'add_menu_button_wide.dart';
import 'search_box_wide.dart';

/// Header MenuPage versi wide: sapaan + judul di kiri, search box di
/// tengah, dan tombol "Tambah Menu" (khusus Admin) di kanan.
class MenuHeaderWide extends StatelessWidget {
  final MenuController controller;
  final String firstName;

  const MenuHeaderWide({
    super.key,
    required this.controller,
    required this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Expanded(
          flex: 2,
          child: SearchBoxWide(controller: controller),
        ),
        if (RoleService.isAdmin) ...[
          const SizedBox(width: 16),
          AddMenuButtonWide(onTap: () => Get.toNamed(AppRoutes.addMenu)),
        ],
      ],
    );
  }
}
