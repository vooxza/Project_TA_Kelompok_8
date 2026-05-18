import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../product_card2.dart';

class CartList extends StatelessWidget {
  final CartController controller;

  const CartList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: controller.cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];

        return Obx(
          () => ProductCard2(
            title: item.product.name,
            description: item.product.description ?? '',
            price: item.product.price.toStringAsFixed(0),
            quantity: item.quantity.value,
            onAdd: () {
              controller.incrementQuantity(
                item.product.id ?? 0,
              );
            },
            onRemove: () {
              controller.decrementQuantity(
                item.product.id ?? 0,
              );
            },
          ),
        );
      },
    );
  }
}