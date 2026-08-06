import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/payment/pay_button_mobile.dart';
import '../../widgets/payment/qr_section_mobile.dart';
import '../../widgets/payment/total_card_mobile.dart';

class PaymentPageMobile extends GetView<CartController> {
  const PaymentPageMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            controller.resetQrisPayment(); 
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
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
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Total card
            TotalCardMobile(controller: controller),
            const SizedBox(height: 20),

            // Instruksi
            const Text(
              'Scan QR Code untuk melakukan pembayaran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // QR section
            QRSectionMobile(controller: controller),

            const SizedBox(height: 24),

            // Pay button
            PayButtonMobile(controller: controller),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}