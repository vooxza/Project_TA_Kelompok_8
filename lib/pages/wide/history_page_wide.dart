import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/history_filter_utils.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/history/empty_orders_mobile.dart';
import '../../widgets/history/filter_indicator.dart';
import '../../widgets/history/filter_sheet.dart';
import '../../widgets/history/history_header.dart';
import '../../widgets/history/paginated_order_list.dart';
import '../../widgets/history/revenue_card.dart';

/// Versi widescreen dari HistoryPage. Dulu didesain sebagai tampilan
/// master-detail (grup per pemesan) — sekarang disederhanakan mengikuti
/// alur & tampilan versi mobile (kartu ringkasan pendapatan lalu daftar
/// pesanan), hanya dipusatkan dengan lebar maksimum supaya nyaman dibaca
/// di layar lebar. Fitur export PDF & filter tanggal/bulan khusus Admin
/// (lihat [HistoryHeader]).
class HistoryPageWide extends GetView<HistoryController> {
  const HistoryPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 760,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HistoryHeader(
            controller: controller,
            onExportPdf: () => HistoryFilterUtils.exportPdf(controller),
            onOpenFilter: () => _showFilterSheet(),
          ),
          const SizedBox(height: 8),
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

              final filteredOrders =
                  HistoryFilterUtils.getFilteredOrders(controller);

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
                          ? HistoryFilterUtils.formatDateLabel(
                              controller.selectedDate.value!)
                          : null,
                      monthLabel:
                          controller.selectedMonthFilter.value != null
                              ? HistoryFilterUtils.formatMonthLabel(
                                  controller.selectedMonthFilter.value!)
                              : null,
                      onClearDate: () => controller.selectedDate.value = null,
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
    );
  }

  void _showFilterSheet() {
    final (_, uniqueMonths) =
        HistoryFilterUtils.uniqueDatesAndMonths(controller);

    // Dipusatkan & dibatasi lebarnya supaya enak dilihat di layar lebar,
    // tapi tetap widget filter yang sama persis dengan versi mobile.
    Get.bottomSheet(
      Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            child: HistoryFilterSheet(
              controller: controller,
              uniqueMonths: uniqueMonths,
              monthNames: HistoryFilterUtils.monthNamesLong,
              monthShort: HistoryFilterUtils.monthNamesShort,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
