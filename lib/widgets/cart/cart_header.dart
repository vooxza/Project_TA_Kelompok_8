import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;
  const CartHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: AppColors.bgCream,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keranjang',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          if (itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$itemCount item',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
