import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../controllers/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  static const List<String> _tables = [
    'Semua Meja',
    'Meja 1',
    'Meja 2',
    'Meja 3',
    'Meja 4',
    'Meja 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

                final filteredOrders = controller.selectedTable.value == null
                    ? controller.orderList
                    : controller.orderList
                        .where(
                          (order) =>
                              order['table_number'].toString().trim() ==
                              controller.selectedTable.value,
                        )
                        .toList();

                return Column(
                  children: [
                    // Revenue card
                    if (controller.isAdmin)
                      _RevenueCard(
                        controller: controller,
                        orders: filteredOrders,
                        isAdmin: true,
                      )
                    else
                      _RevenueCard(
                        controller: controller,
                        orders: filteredOrders,
                        isAdmin: false,
                      ),

                    // Filter indicator
                    if (controller.selectedTable.value != null)
                      _FilterIndicator(
                        label: controller.selectedTable.value!,
                        onClear: () => controller.selectedTable.value = null,
                      ),

                    // Order list
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? _EmptyOrders()
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) =>
                                  _OrderCard(
                                    order: filteredOrders[index],
                                    controller: controller,
                                  ),
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
          Obx(
            () => GestureDetector(
              onTap: () => _showFilterSheet(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: controller.selectedTable.value != null
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
                      color: controller.selectedTable.value != null
                          ? AppColors.primaryRed
                          : AppColors.textMedium,
                    ),
                    if (controller.selectedTable.value != null)
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
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Filter Meja',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _tables.map((table) {
                  final isSelected = table == 'Semua Meja'
                      ? controller.selectedTable.value == null
                      : controller.selectedTable.value == table;

                  return GestureDetector(
                    onTap: () {
                      controller.selectedTable.value =
                          table == 'Semua Meja' ? null : table;
                      Get.back();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryRed
                            : AppColors.bgSurfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryRed
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Text(
                        table,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.textWhite
                              : AppColors.textMedium,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// REVENUE CARD
// ─────────────────────────────────────────────────────────
class _RevenueCard extends StatelessWidget {
  final HistoryController controller;
  final List orders;
  final bool isAdmin;

  const _RevenueCard({
    required this.controller,
    required this.orders,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final filteredOrders = isAdmin
        ? orders
        : orders.where((o) => _isToday(o['created_at']?.toString())).toList();

    final total = filteredOrders.fold<double>(
      0,
      (sum, o) => sum + (double.tryParse(o['total_price'].toString()) ?? 0.0),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D1212), Color(0xFF9B1B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAdmin
                          ? Icons.bar_chart_rounded
                          : Icons.today_rounded,
                      color: Colors.white60,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAdmin
                          ? (controller.selectedTable.value == null
                              ? 'Total Pendapatan'
                              : 'Pendapatan ${controller.selectedTable.value}')
                          : 'Pendapatan Hari Ini',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  controller.formatRupiah(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${filteredOrders.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'transaksi',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(String? isoDate) {
    if (isoDate == null) return false;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      return dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day;
    } catch (_) {
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────
// FILTER INDICATOR
// ─────────────────────────────────────────────────────────
class _FilterIndicator extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const _FilterIndicator({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_alt_rounded,
              size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 6),
          Text(
            'Filter: $label',
            style: const TextStyle(
              color: AppColors.primaryRed,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onClear,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ORDER CARD
// ─────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final dynamic order;
  final HistoryController controller;

  const _OrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List items = order['items'] ?? [];
    final String invoice = order['order_number'] ?? '-';
    final String table = order['table_number'] ?? '-';
    final String date = _formatDate(order['created_at']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_rounded,
                  size: 16,
                  color: AppColors.primaryRed,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.table_restaurant_rounded,
                        size: 12,
                        color: AppColors.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        table,
                        style: const TextStyle(
                          color: AppColors.textMedium,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: items.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item['quantity']}x',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['product_name'] ?? '-',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatRupiah(
                          double.parse(item['price'].toString()),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Column(
              children: [
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      controller.formatRupiah(
                        double.parse(order['total_price'].toString()),
                      ),
                      style: const TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '-';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
    } catch (_) {
      return '-';
    }
  }
}

// ─────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────
class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 42,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Riwayat pesanan akan muncul di sini',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}