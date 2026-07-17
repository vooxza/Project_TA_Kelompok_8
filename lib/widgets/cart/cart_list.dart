import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../dialog_button.dart';
import 'cart_item_card.dart';

class CartList extends StatelessWidget {
  final CartController controller;

  const CartList({
    super.key,
    required this.controller,
  });

  void _confirmDelete(int productId, String name) {
    Get.dialog(
      CustomDialog(
        title: 'Hapus Item?',
        message: 'Yakin ingin menghapus "$name" dari keranjang?',
        textCancel: 'Batal',
        textConfirm: 'Ya, Hapus',
        onCancel: () => Get.back(),
        onConfirm: () => controller.removeFromCart(productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20,
      ),
      itemCount: controller.cartItems.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];

        return Obx(
          () => CartItemCard(
            title: item.product.name,
            description:
                item.product.description ?? '',
            price: item.product.price,
            quantity: item.quantity.value,
            image: item.product.image,
            onAdd: () =>
                controller.incrementQuantity(
              item.product.id ?? 0,
            ),
            onRemove: () =>
                controller.decrementQuantity(
              item.product.id ?? 0,
            ),
            onDelete: () => _confirmDelete(
              item.product.id ?? 0,
              item.product.name,
            ),
          ),
        );
      },
    );
  }
}