import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

/// Bottom sheet pilihan metode pembayaran.
/// Dipanggil dari CartSummary (mobile) maupun SummaryPanelWide (wide).
void showPaymentMethodSheet(BuildContext context) {
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pilih Metode Bayar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pilih cara pembayaran yang diinginkan',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),

          // Tombol QRIS
          _PayMethodButton(
            icon: Icons.qr_code_2_rounded,
            label: 'QRIS',
            description: 'Bayar dengan scan QR Code',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.payment);
            },
          ),

          const SizedBox(height: 12),

          // Tombol Tunai
          _PayMethodButton(
            icon: Icons.payments_outlined,
            label: 'Tunai',
            description: 'Bayar langsung dengan uang tunai',
            color: const Color(0xFF1B6B3A),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.paymentCash);
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

class _PayMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _PayMethodButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.color = AppColors.primaryRed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}