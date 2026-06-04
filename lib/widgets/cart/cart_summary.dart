import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import 'table_dropdown.dart';

class CartSummary extends StatelessWidget {
  final CartController controller;
  const CartSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    final mejaList = ['Meja 1', 'Meja 2', 'Meja 3', 'Meja 4', 'Meja 5'];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
            child: Obx(
              () => DropdownButton<String>(
                value: controller.selectedTable.value,
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.table_restaurant_rounded,
                      size: 18,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Pilih Nomor Meja',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textLight,
                ),
                items: mejaList.map((table) {
                  return DropdownMenuItem(
                    value: table,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.table_restaurant_rounded,
                          size: 18,
                          color: AppColors.primaryRed,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          table,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => controller.selectedTable.value = value,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  controller.formatRupiah(controller.totalPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryRed,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (controller.selectedTable.value == null) {
                  Get.snackbar(
                    'Pilih Meja',
                    'Silakan pilih nomor meja terlebih dahulu',
                    backgroundColor: AppColors.warning,
                    colorText: AppColors.textWhite,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                  );
                  return;
                }
                Get.toNamed(AppRoutes.payment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Lanjut Pembayaran',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.textWhite,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}