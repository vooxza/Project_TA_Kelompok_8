import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/history_controller.dart';
import '../../core/services/pdf_report_service.dart';
import '../../widgets/history/filter_indicator.dart';
import '../../widgets/history/filter_sheet.dart';
import '../../widgets/history/paginated_order_list.dart';
import '../../widgets/history/empty_orders_mobile.dart';
import '../../widgets/history/revenue_card.dart';

/// Versi mobile dari HistoryPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `history_page.dart` cuma jadi switcher tipis.
class HistoryPageMobile extends GetView<HistoryController> {
  const HistoryPageMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                final filteredOrders = _getFilteredOrders();

                return Column(
                  children: [
                    RevenueCard(
                      controller: controller,
                      orders: filteredOrders,
                      isAdmin: controller.isAdmin,
                    ),
                    if (controller.selectedDate.value != null ||
                        controller.selectedMonthFilter.value != null)
                      FilterIndicator(
                        dateLabel: controller.selectedDate.value != null
                            ? _formatDateLabel(controller.selectedDate.value!)
                            : null,
                        monthLabel: controller.selectedMonthFilter.value != null
                            ? _formatMonthLabel(
                                controller.selectedMonthFilter.value!)
                            : null,
                        onClearDate: () =>
                            controller.selectedDate.value = null,
                        onClearMonth: () =>
                            controller.selectedMonthFilter.value = null,
                      ),
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? EmptyOrdersMobile()
                          : PaginatedOrderList(
                              orders: filteredOrders,
                              controller: controller,
                            ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List _getFilteredOrders() {
    return controller.orderList.where((order) {
      if (controller.selectedDate.value != null) {
        return _isSameDate(
            order['created_at']?.toString(), controller.selectedDate.value!);
      }
      if (controller.selectedMonthFilter.value != null) {
        return _isSameMonth(order['created_at']?.toString(),
            controller.selectedMonthFilter.value!);
      }
      return true;
    }).toList();
  }

  bool _isSameDate(String? isoDate, DateTime target) {
    if (isoDate == null) return false;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return dt.year == target.year &&
          dt.month == target.month &&
          dt.day == target.day;
    } catch (_) {
      return false;
    }
  }

  bool _isSameMonth(String? isoDate, DateTime target) {
    if (isoDate == null) return false;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return dt.year == target.year && dt.month == target.month;
    } catch (_) {
      return false;
    }
  }

  String _formatDateLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatMonthLabel(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Ekspor daftar pesanan yang SEDANG TAMPIL (sudah kena filter
  /// tanggal/bulan kalau ada) jadi PDF laporan penjualan.
  Future<void> _exportPdf() async {
    final orders = _getFilteredOrders();

    String? periodLabel;
    if (controller.selectedDate.value != null) {
      periodLabel = _formatDateLabel(controller.selectedDate.value!);
    } else if (controller.selectedMonthFilter.value != null) {
      periodLabel = _formatMonthLabel(controller.selectedMonthFilter.value!);
    }

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      ),
      barrierDismissible: false,
    );
    try {
      await PdfReportService.previewSalesReport(
        orders: orders,
        periodLabel: periodLabel,
      );
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Riwayat\nPesanan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _exportPdf(),
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
          Obx(
            () => GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (controller.selectedDate.value != null ||
                          controller.selectedMonthFilter.value != null)
                      ? AppColors.primaryRed.withValues(alpha: 0.1)
                      : AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 20,
                      color: (controller.selectedDate.value != null ||
                              controller.selectedMonthFilter.value != null)
                          ? AppColors.primaryRed
                          : AppColors.textMedium,
                    ),
                    if (controller.selectedDate.value != null ||
                        controller.selectedMonthFilter.value != null)
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
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    const monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    const monthShort = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    final allDates = controller.orderList
        .map((o) {
          try {
            return DateTime.parse(o['created_at'].toString()).toLocal();
          } catch (_) {
            return null;
          }
        })
        .whereType<DateTime>()
        .map((dt) => DateTime(dt.year, dt.month, dt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final uniqueMonths = allDates
        .map((d) => DateTime(d.year, d.month))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    Get.bottomSheet(
      HistoryFilterSheet(
        controller: controller,
        allDates: allDates,
        uniqueMonths: uniqueMonths,
        monthNames: monthNames,
        monthShort: monthShort,
      ),
      isScrollControlled: true,
    );
  }
}
