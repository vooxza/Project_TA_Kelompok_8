import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/role_service.dart';
import '../../core/services/thermal_print_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../printer/printer_connect_sheet.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read('name') ?? 'User';
    final firstName = name.split(' ').first;

    // Cek status printer saat header dibuild
    ThermalPrintService.checkConnection();

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
              // ✅ Indikator & tombol printer
              _PrinterButton(),

              const SizedBox(width: 8),

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

class _PrinterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final connected = ThermalPrintService.isConnected.value;
      return GestureDetector(
        onTap: () => showPrinterConnectSheet(context),
        child: Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: connected
                    ? AppColors.successLight
                    : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.print_rounded,
                size: 20,
                color: connected
                    ? AppColors.success
                    : AppColors.textMedium,
              ),
            ),
            // Dot status
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: connected
                      ? AppColors.success
                      : AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
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