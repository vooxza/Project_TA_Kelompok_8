import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/wide_page_container.dart';
// ignore: unused_import
import '../../widgets/payment/pay_button_wide.dart';
import '../../widgets/payment/qr_section_wide.dart';
import '../../widgets/payment/total_card_wide.dart';

class PaymentPageWide extends GetView<CartController> {
  const PaymentPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
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
          const SizedBox(height: 28),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiri: Total card + instruksi + tombol bayar
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
    );
  }
}