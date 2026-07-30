import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bottomnav_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../core/services/thermal_print_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class PayButtonWide extends StatelessWidget {
  final CartController controller;

  const PayButtonWide({super.key, required this.controller});

  Future<void> _onConfirm() async {
    final cart = controller;

    // Simpan data cart sebelum di-clear
    final items = cart.cartItems
        .map((item) => {
              'name': item.product.name,
              'quantity': item.quantity.value,
              'price': item.product.price,
            })
        .toList();
    final customerName = cart.selectedTable.value ?? '-';
    final total = cart.totalPrice;

    final success = await cart.checkout(0);
    if (!success) return;

    // ✅ Print nota otomatis
    await ThermalPrintService.printNota(
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      items: items,
      totalPrice: total,
      paymentMethod: 'qris',
    );

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final nav = Get.find<BottomNavController>();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pembayaran\nBerhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nota sedang dicetak...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.clearCart();
                      nav.goToForce(0);
                      Get.offAllNamed(AppRoutes.main);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Menu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : _onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            disabledBackgroundColor: AppColors.borderLight,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Konfirmasi Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
        ),
      ),
    );
  }
}