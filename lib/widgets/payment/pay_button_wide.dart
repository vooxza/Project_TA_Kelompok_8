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

    // Order sudah dibuat sebelumnya (saat QR ditampilkan lewat
    // startQrisPayment). Di sini kita cuma VERIFIKASI ke payment gateway
    // apakah order tsb sudah benar-benar dibayar, bukan bikin order baru.
    cart.isVerifyingPayment.value = true;
    final paid = await cart.verifyQrisPaid();
    cart.isVerifyingPayment.value = false;

    if (!paid) {
      Get.snackbar(
        'Belum Terbayar',
        'Pembayaran QRIS belum terverifikasi. Pastikan sudah scan & bayar, lalu coba lagi.',
        backgroundColor: AppColors.snackbarWarning,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    // ✅ Dialog sukses langsung tampil, print nota jalan di background
    // (printNota punya timeout sendiri, tidak akan menggantung UI).
    _showSuccessDialog();
    ThermalPrintService.printNota(
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      items: items,
      totalPrice: total,
      paymentMethod: 'qris',
    );
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
      () {
        final canConfirm =
            controller.isQrisPaid.value && !controller.isVerifyingPayment.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!controller.isQrisPaid.value) ...[
              const Text(
                'Menunggu konfirmasi pembayaran dari QRIS...',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canConfirm ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  disabledBackgroundColor: AppColors.borderLight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: controller.isVerifyingPayment.value
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
          ],
        );
      },
    );
  }
}