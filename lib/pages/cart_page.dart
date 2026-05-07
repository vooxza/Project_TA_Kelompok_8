import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart/cart_list.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/bottom_nav_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

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

              /// LIST CART
              Expanded(
                child: controller.cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada menu di keranjang",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                      )
                    : CartList(controller: controller),
              ),

              /// SUMMARY
              if (controller.cartItems.isNotEmpty)
                CartSummary(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}