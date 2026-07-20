import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/cart/cart_empty.dart';
import '../../widgets/cart/cart_header.dart';
import '../../widgets/cart/cart_list.dart';
import '../../widgets/cart/cart_summary.dart';

/// Versi mobile dari CartPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `cart_page.dart` cuma jadi switcher tipis.
class CartPageMobile extends GetView<CartController> {
  const CartPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Obx(() {
          final isEmpty = controller.cartItems.isEmpty;
          return Column(
            children: [
              CartHeader(
                itemCount: controller.cartItems.length,
              ),

              if (isEmpty)
                const Expanded(
                  child: CartEmpty(),
                )
              else ...[
                Expanded(
                  child: CartList(
                    controller: controller,
                  ),
                ),

                CartSummary(
                  controller: controller,
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
