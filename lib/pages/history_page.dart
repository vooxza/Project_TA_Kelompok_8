import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../controllers/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

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
                    _RevenueCard(
                      controller: controller,
                      orders: filteredOrders,
                      isAdmin: controller.isAdmin,
                    ),
                    if (controller.selectedDate.value != null)
                      _FilterIndicator(
                        dateLabel: _formatDateLabel(controller.selectedDate.value!),
                        onClearDate: () => controller.selectedDate.value = null,
                      ),
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? _EmptyOrders()
                          : _PaginatedOrderList(
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
      final dateMatch = controller.selectedDate.value == null ||
          _isSameDate(
              order['created_at']?.toString(), controller.selectedDate.value!);
      return dateMatch;
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

  String _formatDateLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
                  color: controller.selectedDate.value != null
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
                      color: controller.selectedDate.value != null
                          ? AppColors.primaryRed
                          : AppColors.textMedium,
                    ),
                    if (controller.selectedDate.value != null)
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
      _FilterSheet(
        controller: controller,
        allDates: allDates,
        uniqueMonths: uniqueMonths,
        monthNames: monthNames,
        monthShort: monthShort,
      ),
      isScrollControlled: true,
    );
  }

  bool _isSameDateStatic(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// ─────────────────────────────────────────────────────────
// FILTER SHEET
// ─────────────────────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  final HistoryController controller;
  final List<DateTime> allDates;
  final List<DateTime> uniqueMonths;
  final List<String> monthNames;
  final List<String> monthShort;

  const _FilterSheet({
    required this.controller,
    required this.allDates,
    required this.uniqueMonths,
    required this.monthNames,
    required this.monthShort,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  DateTime? selectedMonth;

  @override
  void initState() {
    super.initState();
    if (widget.controller.selectedDate.value != null) {
      selectedMonth = DateTime(
        widget.controller.selectedDate.value!.year,
        widget.controller.selectedDate.value!.month,
      );
    }
  }

  bool _isSame(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);

    final datesInMonth = selectedMonth == null
        ? <DateTime>[]
        : widget.allDates
            .where((d) =>
                d.year == selectedMonth!.year &&
                d.month == selectedMonth!.month)
            .toList();

    final hasDataDays = datesInMonth.map((d) => d.day).toSet();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: SingleChildScrollView(
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
              'Filter Tanggal',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FilterChip(
                      label: 'Semua',
                      isSelected: widget.controller.selectedDate.value == null,
                      onTap: () {
                        widget.controller.selectedDate.value = null;
                        Get.back();
                      },
                    ),
                    _FilterChip(
                      label: 'Hari Ini',
                      isSelected: widget.controller.selectedDate.value != null &&
                          _isSame(widget.controller.selectedDate.value!, todayOnly),
                      onTap: () {
                        widget.controller.selectedDate.value = todayOnly;
                        Get.back();
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Text(
              'Pilih Bulan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.uniqueMonths.map((month) {
                final isActive = selectedMonth != null &&
                    selectedMonth!.year == month.year &&
                    selectedMonth!.month == month.month;
                final label =
                    '${widget.monthShort[month.month - 1]} ${month.year}';
                return _FilterChip(
                  label: label,
                  isSelected: isActive,
                  onTap: () {
                    setState(() {
                      selectedMonth = isActive ? null : month;
                    });
                  },
                );
              }).toList(),
            ),
            if (selectedMonth != null) ...[
              const SizedBox(height: 20),
              Text(
                'Tanggal di ${widget.monthNames[selectedMonth!.month - 1]} ${selectedMonth!.year}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                final daysInMonth = DateUtils.getDaysInMonth(
                  selectedMonth!.year,
                  selectedMonth!.month,
                );
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(daysInMonth, (i) {
                    final day = i + 1;
                    final date = DateTime(
                      selectedMonth!.year,
                      selectedMonth!.month,
                      day,
                    );
                    final isSelected =
                        widget.controller.selectedDate.value != null &&
                            _isSame(widget.controller.selectedDate.value!, date);
                    return _DateChip(
                      label: '$day',
                      isSelected: isSelected,
                      onTap: () {
                        widget.controller.selectedDate.value = date;
                        Get.back();
                      },
                    );
                  }),
                );
              }),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.controller.selectedDate.value = null;
                  Get.back();
                },
                icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                label: const Text(
                  'Hapus Filter',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  side: const BorderSide(
                    color: AppColors.primaryRed,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// FILTER CHIP
// ─────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasData;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.hasData = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textWhite : AppColors.textMedium,
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textWhite : AppColors.textMedium,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PAGINATED ORDER LIST
// ─────────────────────────────────────────────────────────
class _PaginatedOrderList extends StatefulWidget {
  final List orders;
  final HistoryController controller;

  const _PaginatedOrderList({
    required this.orders,
    required this.controller,
  });

  @override
  State<_PaginatedOrderList> createState() => _PaginatedOrderListState();
}

class _PaginatedOrderListState extends State<_PaginatedOrderList> {
  static const int _pageSize = 5;
  int _currentCount = _pageSize;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_PaginatedOrderList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orders != widget.orders) {
      setState(() => _currentCount = _pageSize);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _currentCount < widget.orders.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _currentCount = (_currentCount + _pageSize).clamp(0, widget.orders.length);
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = widget.orders.take(_currentCount).toList();
    final hasMore = _currentCount < widget.orders.length;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: visibleOrders.length + (hasMore || _isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < visibleOrders.length) {
          return _OrderCard(
            order: visibleOrders[index],
            controller: widget.controller,
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _isLoadingMore
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryRed,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Scroll untuk memuat lebih banyak',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
          ),
        );
      },
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
    final total = orders.fold<double>(
      0,
      (sum, o) => sum + (double.tryParse(o['total_price'].toString()) ?? 0.0),
    );

    String label;
    if (controller.selectedDate.value != null) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      final d = controller.selectedDate.value!;
      final dateStr = '${d.day} ${months[d.month - 1]} ${d.year}';
      label = 'Pendapatan $dateStr';
    } else if (isAdmin) {
      label = controller.selectedTable.value == null
          ? 'Total Pendapatan'
          : 'Pendapatan ${controller.selectedTable.value}';
    } else {
      label = 'Pendapatan Hari Ini';
    }

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
                      controller.selectedDate.value != null
                          ? Icons.calendar_today_rounded
                          : (isAdmin
                              ? Icons.bar_chart_rounded
                              : Icons.today_rounded),
                      color: Colors.white60,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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
                  '${orders.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'transaksi',
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// FILTER INDICATOR
// ─────────────────────────────────────────────────────────
class _FilterIndicator extends StatelessWidget {
  final String? dateLabel;
  final VoidCallback onClearDate;

  const _FilterIndicator({
    this.dateLabel,
    required this.onClearDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_rounded,
              size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              spacing: 6,
              children: [
                if (dateLabel != null)
                  _BadgeChip(label: dateLabel!, onClear: onClearDate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const _BadgeChip({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryRed,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close_rounded,
                size: 13, color: AppColors.primaryRed),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ORDER CARD  —  font diperbesar
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              color: AppColors.bgSurfaceLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_rounded,
                    size: 18, color: AppColors.primaryRed),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                      fontSize: 15,           // sebelumnya 13
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          size: 14, color: AppColors.textMedium),
                      const SizedBox(width: 4),
                      Text(
                        table,
                        style: const TextStyle(
                          color: AppColors.textMedium,
                          fontSize: 13,       // sebelumnya 11
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 13,           // sebelumnya 11
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item['quantity']}x',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,     // sebelumnya 11
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['product_name'] ?? '-',
                          style: const TextStyle(
                            fontSize: 15,     // sebelumnya 13
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatRupiah(
                          double.parse(item['price'].toString()),
                        ),
                        style: const TextStyle(
                          fontSize: 14,       // sebelumnya 12
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
                        fontSize: 15,         // sebelumnya 13
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
                        fontSize: 17,         // sebelumnya 15
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,         // sebelumnya 11
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
            decoration: const BoxDecoration(
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
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}