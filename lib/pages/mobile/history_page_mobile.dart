import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/history_filter_utils.dart';
import '../../widgets/history/empty_orders_mobile.dart';
import '../../widgets/history/filter_indicator.dart';
import '../../widgets/history/filter_sheet.dart';
import '../../widgets/history/history_header.dart';
import '../../widgets/history/paginated_order_list.dart';
import '../../widgets/history/revenue_card.dart';

/// Versi mobile dari HistoryPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `history_page.dart` cuma jadi switcher tipis.
class HistoryPageMobile extends GetView<HistoryController> {
  const HistoryPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
          child: Column(
            children: [
              HistoryHeader(
                controller: controller,
                title: 'Riwayat\nPesanan',
                onExportPdf: () => HistoryFilterUtils.exportPdf(controller),
                onOpenFilter: () => _showFilterSheet(context),
              ),
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
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final (_, uniqueMonths) =
        HistoryFilterUtils.uniqueDatesAndMonths(controller);

    Get.bottomSheet(
      HistoryFilterSheet(
        controller: controller,
        uniqueMonths: uniqueMonths,
        monthNames: HistoryFilterUtils.monthNamesLong,
        monthShort: HistoryFilterUtils.monthNamesShort,
      ),
      isScrollControlled: true,
    );
  }
}
