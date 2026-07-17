import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/history/filter_indicator.dart';
import '../../widgets/history/filter_sheet.dart';
import '../../widgets/history/order_card.dart';
import '../../widgets/history/revenue_card.dart';

/// Versi widescreen dari HistoryPage. Data sama persis (dari
/// [HistoryController.orderList]) — hanya reflow jadi tampilan master-detail:
/// kiri = daftar pemesan, kanan = daftar pesanan untuk pemesan yang dipilih.
///
/// Catatan penting: field `table_number` di data order ini sebenarnya diisi
/// dari input "Atas Nama" di halaman Keranjang (bukan nomor meja tetap),
/// karena pelanggan bisa pindah meja. Jadi pengelompokan di halaman ini
/// SENGAJA dilabeli sebagai "Pemesan", bukan "Meja", supaya sesuai dengan
/// makna data yang sebenarnya. Memakai `controller.selectedTable` yang
/// sudah tersedia di controller (sebelumnya belum dipakai di versi mobile).
/// Filter tanggal/bulan juga sama persis dengan versi mobile (pakai
/// [HistoryFilterSheet] yang sama).
class HistoryPageWide extends GetView<HistoryController> {
  const HistoryPageWide({super.key});

  /// Label yang ditampilkan untuk tiap grup pemesan. Ditampilkan apa
  /// adanya (tanpa prefix "Meja") karena isiannya bisa berupa nama
  /// ("Aldesta") maupun angka ("1") tergantung apa yang diketik di
  /// "Atas Nama" saat checkout.
  String _ordererLabel(String name) => name;

  Map<String, List> _groupByOrderer(List orders) {
    final Map<String, List> grouped = {};
    for (final order in orders) {
      final name = (order['table_number'] ?? '-').toString();
      grouped.putIfAbsent(name, () => []).add(order);
    }
    return grouped;
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

    // Dipusatkan & dibatasi lebarnya supaya enak dilihat di layar lebar,
    // tapi tetap widget filter yang sama persis dengan versi mobile.
    Get.bottomSheet(
      Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: HistoryFilterSheet(
              controller: controller,
              allDates: allDates,
              uniqueMonths: uniqueMonths,
              monthNames: monthNames,
              monthShort: monthShort,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            'Riwayat Pesanan',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Obx(
          () => GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (controller.selectedDate.value != null ||
                        controller.selectedMonthFilter.value != null)
                    ? AppColors.primaryRed.withOpacity(0.1)
                    : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: (controller.selectedDate.value != null ||
                            controller.selectedMonthFilter.value != null)
                        ? AppColors.primaryRed
                        : AppColors.textMedium,
                  ),
                  if (controller.selectedDate.value != null ||
                      controller.selectedMonthFilter.value != null)
                    Positioned(
                      top: 9,
                      right: 9,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgCream,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Obx(() {
                    if (controller.selectedDate.value == null &&
                        controller.selectedMonthFilter.value == null) {
                      return const SizedBox(height: 18);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 14, bottom: 4),
                      child: FilterIndicator(
                        dateLabel: controller.selectedDate.value != null
                            ? _formatDateLabel(controller.selectedDate.value!)
                            : null,
                        monthLabel:
                            controller.selectedMonthFilter.value != null
                                ? _formatMonthLabel(
                                    controller.selectedMonthFilter.value!)
                                : null,
                        onClearDate: () =>
                            controller.selectedDate.value = null,
                        onClearMonth: () =>
                            controller.selectedMonthFilter.value = null,
                      ),
                    );
                  }),
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

                      final orders = _getFilteredOrders();
                      final grouped = _groupByOrderer(orders);
                      final orderers = grouped.keys.toList()..sort();

                      if (orderers.isEmpty) {
                        return const Center(
                          child: Text(
                            'Belum ada pesanan',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textLight,
                            ),
                          ),
                        );
                      }

                      // Default pilih pemesan pertama kalau belum ada yang
                      // dipilih / pilihan sebelumnya sudah tidak ada order-nya.
                      if (controller.selectedTable.value == null ||
                          !orderers.contains(controller.selectedTable.value)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.selectedTable.value = orderers.first;
                        });
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kiri: daftar pemesan (bukan meja tetap — nilainya
                          // berasal dari input "Atas Nama" di Keranjang)
                          SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10, left: 4),
                                  child: Text(
                                    'BERDASARKAN NAMA PEMESAN',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textLight,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: orderers.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final name = orderers[index];
                                      final ordererOrders = grouped[name]!;
                                      final isSelected = controller
                                              .selectedTable.value ==
                                          name;

                                      return GestureDetector(
                                        onTap: () => controller
                                            .selectedTable.value = name,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primaryRed
                                                : AppColors.bgWhite,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.shadowDark,
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .person_outline_rounded,
                                                      size: 16,
                                                      color: isSelected
                                                          ? Colors.white70
                                                          : AppColors
                                                              .textLight,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        _ordererLabel(name),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : AppColors
                                                                  .textDark,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${ordererOrders.length}x',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isSelected
                                                          ? Colors.white70
                                                          : AppColors
                                                              .textLight,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_rounded,
                                                    size: 16,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : AppColors.textLight,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Kanan: detail pesanan pemesan terpilih
                          Expanded(
                            child: Obx(() {
                              final name = controller.selectedTable.value;
                              final ordererOrders =
                                  name != null ? (grouped[name] ?? []) : [];

                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  RevenueCard(
                                    controller: controller,
                                    orders: ordererOrders,
                                    isAdmin: controller.isAdmin,
                                  ),
                                  Expanded(
                                    child: ordererOrders.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Pilih pemesan untuk melihat riwayat',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.textLight,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 4, 20, 20),
                                            itemCount: ordererOrders.length,
                                            itemBuilder: (context, index) {
                                              return OrderCard(
                                                order: ordererOrders[index],
                                                controller: controller,
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
