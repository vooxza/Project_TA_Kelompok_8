import 'package:flutter/material.dart';
import '../category_card.dart';

class CategorySection extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Makanan', 'icon': Icons.restaurant},
      {'name': 'Minuman', 'icon': Icons.local_drink},
      {'name': 'Tambahan', 'icon': Icons.shopping_bag},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return CategoryCard(
            title: category['name'] as String,
            isSelected: selectedCategory == category['name'],
            onTap: () => onCategorySelected(category['name'] as String),
            icon: category['icon'] as IconData,
          );
        }).toList(),
      ),
    );
  }
}