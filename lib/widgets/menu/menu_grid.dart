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
    if (items.isEmpty) {
      return const Center(
        child: Text('Tidak ada menu'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
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