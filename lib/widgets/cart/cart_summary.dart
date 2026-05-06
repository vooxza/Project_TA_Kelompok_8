import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../controllers/cart_controller.dart';
import 'table_dropdown.dart';
import '../../../../../routes/app_routes.dart';

class CartSummary extends StatelessWidget {
  final CartController controller;

  const CartSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          TableDropdown(controller: controller),

          const SizedBox(height: 20),

          /// TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Harga",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                controller.formatRupiah(controller.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// BUTTON
          GestureDetector(
            onTap: () {
              if (controller.selectedTable.value == null) {
                Get.snackbar(
                  "Peringatan",
                  "Silakan pilih nomor meja",
                  backgroundColor: AppColors.warning,
                  colorText: AppColors.textWhite,
                );
                return;
              }

              Get.toNamed(AppRoutes.payment);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "LANJUT",
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}