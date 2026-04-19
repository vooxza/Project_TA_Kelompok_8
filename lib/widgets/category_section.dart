import 'package:flutter/material.dart';
import 'category_card.dart';

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
      {
        'name': 'Makanan',
        'icon': Icons.restaurant,
      },
      {
        'name': 'Minuman',
        'icon': Icons.local_drink,
      },
      {
        'name': 'Tambahan',
        'icon': Icons.shopping_bag,
      },
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Kategori",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            categories.length,
            (index) {
              final category = categories[index];
              return CategoryCard(
                title: category['name'] as String,
                isSelected: selectedCategory == category['name'],
                onTap: () => onCategorySelected(category['name'] as String),
                icon: category['icon'] as IconData,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
