import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../controllers/menu_controller.dart';

class MenuGrid extends StatelessWidget {
  final int? selectedCategoryId;

  const MenuGrid({
    super.key,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = Get.find<MenuController>();

    return Obx(() {
      final filteredItems = selectedCategoryId == null
          ? menuController.menuItems
          : menuController.menuItems
              .where((item) => item.categoryId == selectedCategoryId)
              .toList();

      if (filteredItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No products available',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textGreyLight,
              ),
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return _buildMenuCard(context, item);
        },
      );
    });
  }

  Widget _buildMenuCard(BuildContext context, item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Container(
              width: double.infinity,
              height: 120,
              color: AppColors.bgGreyLight,
              child: item.image != null
                  ? Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.fastfood,
                        color: AppColors.textGrey,
                        size: 40,
                      ),
                    )
                  : const Icon(
                      Icons.fastfood,
                      color: AppColors.textGrey,
                      size: 40,
                    ),
            ),
          ),
          // Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGreyLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryRed,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add to cart logic here
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textWhite,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
