import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/bottomnav_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/dialog_button.dart';
import '../../widgets/payment/pay_button_wide.dart';
import '../../widgets/payment/qr_section_wide.dart';
import '../../widgets/payment/total_card_wide.dart';

/// Versi widescreen dari PaymentPage. Sama seperti versi mobile (QRIS,
/// total, tombol "Saya Sudah Bayar", dialog sukses) — hanya reflow jadi
/// dua kolom: kartu total di kiri, QR + tombol bayar di kanan.
class PaymentPageWide extends GetView<CartController> {
  const PaymentPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
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
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showCancelDialog(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Pembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kiri: Total card + info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TotalCardWide(controller: controller),
                            const SizedBox(height: 20),
                            const Text(
                              'Scan QR Code untuk melakukan pembayaran',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textMedium,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            PayButtonWide(controller: controller),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Kanan: QR section
                      Expanded(
                        child: QRSectionWide(controller: controller),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog() {
    Get.dialog(
      CustomDialog(
        title: 'Batalkan Pesanan?',
        message: 'Apakah yakin ingin membatalkan pesanan ini?',
        textCancel: 'Tidak',
        textConfirm: 'Ya, Batalkan',
        onCancel: () => Get.back(),
        onConfirm: () {
          Get.back();
          controller.clearCart();
          Get.find<BottomNavController>().goToForce(0);
          Get.offAllNamed(AppRoutes.main);
        },
      ),
    );
  }
}
