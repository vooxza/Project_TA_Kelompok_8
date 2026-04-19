import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : AppColors.bgGreyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon ?? Icons.restaurant_menu,
              color: isSelected ? AppColors.textWhite : AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : AppColors.bgGreyLight,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.textWhite : AppColors.textBlack,
              ),
            ),
          )
        ],
      ),
    );
  }
}
