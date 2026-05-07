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
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.textWhite,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            onPressed: () {
              cartController.addToCart(item);

              Get.snackbar(
                'Berhasil',
                '${item.name} ditambahkan',
                backgroundColor: AppColors.primaryRed,
                colorText: AppColors.textWhite,
              );
            },
          ),

          if (quantity > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  quantity.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
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