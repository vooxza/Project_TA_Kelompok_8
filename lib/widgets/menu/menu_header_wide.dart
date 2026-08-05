import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../controllers/menu_controller.dart';
import '../../core/services/role_service.dart';
import '../../core/services/thermal_print_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../printer/printer_connect_sheet.dart';
import 'add_menu_button_wide.dart';
import 'search_box_wide.dart';

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
    ThermalPrintService.checkConnection();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Greeting
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

        // ✅ Indikator & tombol printer
        _PrinterButtonWide(),

        if (RoleService.isAdmin) ...[
          const SizedBox(width: 12),
          AddMenuButtonWide(onTap: () => Get.toNamed(AppRoutes.addMenu)),
        ],
      ],
    );
  }
}

class _PrinterButtonWide extends StatelessWidget {
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
                  color: connected ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}