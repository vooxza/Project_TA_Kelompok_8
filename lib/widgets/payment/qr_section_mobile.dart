import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';

/// Kartu QRIS untuk halaman Pembayaran mobile.
class QRSectionMobile extends StatelessWidget {
  final CartController controller;
  const QRSectionMobile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'QRIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'SOTO MBOK KERSO',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 20),

          // QR code box
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderLight,
                width: 2,
              ),
            ),
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              child: Center(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 180,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Divider
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

          // Amount + table
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
              ),
              Obx(
                () => Text(
                  controller.formatRupiah(controller.totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PAY BUTTON
// ─────────────────────────────────────────────────────────
