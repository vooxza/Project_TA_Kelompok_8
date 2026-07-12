import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';

class RevenueCard extends StatelessWidget {
  final HistoryController controller;
  final List orders;
  final bool isAdmin;

  const RevenueCard({
    super.key,
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
      label = 'Pendapatan ${d.day} ${months[d.month - 1]} ${d.year}';
    } else if (controller.selectedMonthFilter.value != null) {
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ];
      final m = controller.selectedMonthFilter.value!;
      label = 'Pendapatan ${months[m.month - 1]} ${m.year}';
    } else if (isAdmin) {
      label = 'Total Pendapatan';
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
                          : controller.selectedMonthFilter.value != null
                              ? Icons.calendar_month_rounded
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