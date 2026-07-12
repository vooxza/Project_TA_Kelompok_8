import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FilterIndicator extends StatelessWidget {
  final String? dateLabel;
  final String? monthLabel;
  final VoidCallback onClearDate;
  final VoidCallback onClearMonth;

  const FilterIndicator({
    super.key,
    this.dateLabel,
    this.monthLabel,
    required this.onClearDate,
    required this.onClearMonth,
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
                if (monthLabel != null)
                  _BadgeChip(label: monthLabel!, onClear: onClearMonth),
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