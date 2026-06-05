import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read('name') ?? 'User';
    final firstName = name.split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting text
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
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Action buttons
          Row(
            children: [
              if (RoleService.isAdmin)
                _HeaderButton(
                  icon: Icons.add_rounded,
                  color: AppColors.primaryRed,
                  onTap: () => Get.toNamed(AppRoutes.addMenu),
                ),
              if (RoleService.isAdmin) const SizedBox(width: 8),
              _HeaderButton(
                icon: Icons.person_outline_rounded,
                color: AppColors.bgSurface,
                iconColor: AppColors.textDark,
                onTap: () => Get.toNamed(AppRoutes.profile),
              ),
            ],
          ),
        ],
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? AppColors.textWhite,
        ),
      ),
    );
  }
}