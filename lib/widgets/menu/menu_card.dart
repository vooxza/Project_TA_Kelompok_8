import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../core/services/api_service.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/cart/cart_badge_button.dart';

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
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: item,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textBlack.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: item.image != null && item.image!.isNotEmpty
                          ? Image.network(
                              item.image!.startsWith('http')
                                  ? item.image!
                                  : '${ApiService.baseUrl.replaceAll('/api', '')}${item.image}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.bgGrey,
                                child: const Icon(
                                  Icons.fastfood,
                                  size: 40,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.bgGrey,
                              child: const Icon(
                                Icons.fastfood,
                                size: 40,
                                color: AppColors.textGrey,
                              ),
                            ),
                    ),

                    /// EDIT BUTTON (ADMIN ONLY)
                    if (RoleService.isAdmin)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.editMenu,
                            arguments: {
                              'id': item.id,
                              'name': item.name,
                              'description': item.description,
                              'category_id': item.categoryId,
                              'price': item.price,
                              'image': item.image,
                            },
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.textWhite,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// INFO
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textBlack,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    item.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGreyLight,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),

                      /// CART BUTTON + BADGE
                      CartBadgeButton(
                        item: item,
                        cartController: cartController,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}