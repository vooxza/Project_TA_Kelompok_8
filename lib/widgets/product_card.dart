import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white24,
              child: Image.asset(
                "assets/images/soto.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fastfood,
                  color: AppColors.textWhite,
                  size: 50,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xB2FFFFFF),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentRedLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.remove, color: AppColors.textWhite, size: 18),
                SizedBox(width: 8),
                Text(
                  "1",
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.add, color: AppColors.textWhite, size: 18),
              ],
            ),
          )
        ],
      ),
    );
  }
}
