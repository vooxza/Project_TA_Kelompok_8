import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';

/// Header halaman Riwayat: judul + tombol export PDF & filter.
/// Tombol export PDF dan filter **hanya tampil untuk Admin** — untuk
/// Kasir/User, daftar order per pemesan/meja sering kosong sehingga
/// membuka filter/export bisa memicu error, jadi kedua tombol ini
/// disembunyikan sepenuhnya untuk role selain Admin.
class HistoryHeader extends StatelessWidget {
  final HistoryController controller;
  final String title;
  final VoidCallback onExportPdf;
  final VoidCallback onOpenFilter;
  final TextStyle titleStyle;

  const HistoryHeader({
    super.key,
    required this.controller,
    required this.onExportPdf,
    required this.onOpenFilter,
    this.title = 'Riwayat Pesanan',
    this.titleStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.textDark,
      height: 1.2,
      letterSpacing: -0.5,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: titleStyle),
        ),
        if (controller.isAdmin) ...[
          GestureDetector(
            onTap: onExportPdf,
            child: Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                size: 20,
                color: AppColors.textMedium,
              ),
            ),
          ),
          Obx(() {
            final hasFilter = controller.selectedDate.value != null ||
                controller.selectedMonthFilter.value != null;
            return GestureDetector(
              onTap: onOpenFilter,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: hasFilter
                      ? AppColors.primaryRed.withOpacity(0.1)
                      : AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 20,
                      color: hasFilter
                          ? AppColors.primaryRed
                          : AppColors.textMedium,
                    ),
                    if (hasFilter)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
