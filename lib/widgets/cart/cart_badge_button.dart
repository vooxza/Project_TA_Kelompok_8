import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/product_model.dart';

class CartBadgeButton extends StatelessWidget {
  final Product item;
  final CartController cartController;

  const CartBadgeButton({
    super.key,
    required this.item,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quantity =
          cartController.getItemQuantity(item.id ?? 0);

      return Stack(
        clipBehavior: Clip.none,
        children: [
          /// BUTTON
          GestureDetector(
            onTap: () {
              cartController.addToCart(item);

              Get.snackbar(
                'Berhasil',
                '${item.name} ditambahkan',
                backgroundColor: AppColors.primaryRed,
                colorText: AppColors.textWhite,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(12),
                borderRadius: 12,
              );
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
                size: 16,
              ),
            ),
          ),

          /// BADGE
          if (quantity > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textBlack,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.textWhite,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  quantity.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}