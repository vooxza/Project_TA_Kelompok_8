import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

/// Panel ringkasan pesanan (atas nama, total, tombol lanjut
/// pembayaran) untuk halaman Keranjang wide.
class SummaryPanelWide extends StatefulWidget {
  final CartController controller;
  const SummaryPanelWide({required this.controller});

  @override
  State<SummaryPanelWide> createState() => SummaryPanelWideState();
}

class SummaryPanelWideState extends State<SummaryPanelWide> {
  late final TextEditingController _nameController;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          // Atas nama
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    size: 18, color: AppColors.textLight),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) => widget.controller.selectedTable
                        .value = value.trim().isEmpty ? null : value.trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      hintText: 'Atas Nama',
                      hintStyle: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

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

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (widget.controller.selectedTable.value == null ||
                    widget.controller.selectedTable.value!.trim().isEmpty) {
                  Get.snackbar(
                    'Atas Nama Kosong',
                    'Silakan isi nama terlebih dahulu',
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
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.textWhite, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
