import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../core/theme/app_colors.dart';
import '../widgets/cart/cart_empty.dart';
import '../widgets/cart/cart_list.dart';
import '../widgets/cart/cart_summary.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: controller.cartItems.isEmpty
                    ? const CartEmpty()
                    : Column(
                        children: [
                          Expanded(child: CartList(controller: controller)),

                          CartSummary(controller: controller),
                        ],
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
