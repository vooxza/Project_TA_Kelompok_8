import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class CartSummary extends StatefulWidget {
  final CartController controller;
  const CartSummary({required this.controller});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  late final TextEditingController _nameController;
  String? _selectedMethod; // 'tunai' atau 'qris'

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller.selectedTable.value ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onLanjut() {
    if (widget.controller.selectedTable.value == null ||
        widget.controller.selectedTable.value!.trim().isEmpty) {
      Get.snackbar(
        'Atas Nama Kosong',
        'Silakan isi nama terlebih dahulu',
        backgroundColor: AppColors.snackbarWarning,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }
    if (_selectedMethod == null) {
      Get.snackbar(
        'Metode Belum Dipilih',
        'Silakan pilih metode pembayaran terlebih dahulu',
        backgroundColor: AppColors.snackbarWarning,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }
    if (_selectedMethod == 'qris') {
      Get.toNamed(AppRoutes.payment);
    } else {
      Get.toNamed(AppRoutes.paymentCash);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Atas Nama input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: AppColors.textLight,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) =>
                        widget.controller.selectedTable.value =
                            value.trim().isEmpty ? null : value.trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      hintText: 'Atas Nama',
                      hintStyle: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Pilih metode bayar
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MethodCard(
                  icon: Icons.payments_outlined,
                  label: 'Tunai',
                  isSelected: _selectedMethod == 'tunai',
                  color: const Color(0xFF1B6B3A),
                  onTap: () => setState(() => _selectedMethod = 'tunai'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MethodCard(
                  icon: Icons.qr_code_2_rounded,
                  label: 'QRIS',
                  isSelected: _selectedMethod == 'qris',
                  color: AppColors.primaryRed,
                  onTap: () => setState(() => _selectedMethod = 'qris'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

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
                  widget.controller.formatRupiah(widget.controller.totalPrice),
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

          const SizedBox(height: 14),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _onLanjut,
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

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.borderLight,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : AppColors.textLight),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}