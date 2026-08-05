import 'package:flutter/material.dart' hide FilterChip;
import 'package:get/get.dart';
import '../../controllers/history_controller.dart';
import '../../core/theme/app_colors.dart';
import 'filter_chips.dart';

class HistoryFilterSheet extends StatefulWidget {
  final HistoryController controller;
  final List<DateTime> uniqueMonths;
  final List<String> monthNames;
  final List<String> monthShort;

  const HistoryFilterSheet({
    super.key,
    required this.controller,
    required this.uniqueMonths,
    required this.monthNames,
    required this.monthShort,
  });

  @override
  State<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<HistoryFilterSheet> {
  DateTime? expandedMonth;

  bool _isSame(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);

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
            // Handle bar
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
              'Filter',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // Semua & Hari Ini
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: 'Semua',
                      isSelected:
                          widget.controller.selectedDate.value == null &&
                              widget.controller.selectedMonthFilter.value ==
                                  null,
                      onTap: () {
                        widget.controller.selectedDate.value = null;
                        widget.controller.selectedMonthFilter.value = null;
                        Get.back();
                      },
                    ),
                    FilterChip(
                      label: 'Hari Ini',
                      isSelected:
                          widget.controller.selectedDate.value != null &&
                              _isSame(widget.controller.selectedDate.value!,
                                  todayOnly),
                      onTap: () {
                        widget.controller.selectedDate.value = todayOnly;
                        widget.controller.selectedMonthFilter.value = null;
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
            const SizedBox(height: 4),
            const Text(
              'Klik sekali untuk pilih tanggal, klik lagi untuk filter bulan',
              style: TextStyle(fontSize: 11, color: AppColors.textLight),
            ),
            const SizedBox(height: 10),

            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.uniqueMonths.map((month) {
                    final isExpanded = expandedMonth != null &&
                        _isSameMonth(expandedMonth!, month);
                    final isMonthSelected =
                        widget.controller.selectedMonthFilter.value != null &&
                            _isSameMonth(
                                widget.controller.selectedMonthFilter.value!,
                                month);
                    final label =
                        '${widget.monthShort[month.month - 1]} ${month.year}';

                    return FilterChip(
                      label: label,
                      isSelected: isMonthSelected,
                      trailing: isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      onTap: () {
                        if (isExpanded) {
                          widget.controller.selectedMonthFilter.value = month;
                          widget.controller.selectedDate.value = null;
                          Get.back();
                        } else {
                          setState(() => expandedMonth = month);
                        }
                      },
                    );
                  }).toList(),
                )),

            // Grid tanggal
            if (expandedMonth != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal di ${widget.monthNames[expandedMonth!.month - 1]} ${expandedMonth!.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => expandedMonth = null),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                final daysInMonth = DateUtils.getDaysInMonth(
                  expandedMonth!.year,
                  expandedMonth!.month,
                );
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(daysInMonth, (i) {
                    final day = i + 1;
                    final date = DateTime(
                      expandedMonth!.year,
                      expandedMonth!.month,
                      day,
                    );
                    final isSelected =
                        widget.controller.selectedDate.value != null &&
                            _isSame(
                                widget.controller.selectedDate.value!, date);
                    return DateChip(
                      label: '$day',
                      isSelected: isSelected,
                      onTap: () {
                        widget.controller.selectedDate.value = date;
                        widget.controller.selectedMonthFilter.value = null;
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
                  widget.controller.selectedMonthFilter.value = null;
                  Get.back();
                },
                icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                label: const Text(
                  'Hapus Filter',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  side: const BorderSide(
                      color: AppColors.primaryRed, width: 1.5),
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