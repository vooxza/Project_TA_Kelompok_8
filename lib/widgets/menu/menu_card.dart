import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../controllers/cart_controller.dart';
import '../../core/services/api_service.dart';

class MenuCard extends StatelessWidget {
  final dynamic item;
  final CartController cartController;

  const MenuCard({
    super.key,
    required this.item,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: item.image != null && item.image!.isNotEmpty
                      ? Image.network(
                          item.image!.startsWith('http')
                              ? item.image!
                              : '${ApiService.baseUrl.replaceAll('/api', '')}${item.image}',
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.fastfood, size: 40),
                ),

                /// EDIT BUTTON
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    color: AppColors.textWhite,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                    ),
                    onPressed: () => Get.toNamed(
                      AppRoutes.editMenu,
                      arguments: {
                        'id': item.id,
                        'name': item.name,
                        'price': item.price,
                        'image': item.image,
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// INFO
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.textWhite,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                        ),
                        onPressed: () {
                          cartController.addToCart(item);
                          Get.snackbar(
                            "Berhasil",
                            "${item.name} ditambahkan",
                            backgroundColor: AppColors.primaryRed,
                            colorText: AppColors.textWhite,
                          );
                        },
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