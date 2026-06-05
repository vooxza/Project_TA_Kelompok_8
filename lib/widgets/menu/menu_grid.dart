import 'package:flutter/material.dart';
import '../../../../controllers/cart_controller.dart';
import 'menu_card.dart';

class MenuGrid extends StatelessWidget {
  final List items;
  final CartController cartController;

  const MenuGrid({
    super.key,
    required this.items,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.76,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MenuCard(
          item: items[index],
          cartController: cartController,
        );
      },
    );
  }
}