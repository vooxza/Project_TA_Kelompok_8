import 'package:flutter/material.dart';
import '../../../../controllers/cart_controller.dart';
import 'menu_card.dart';

class MenuGrid extends StatelessWidget {
  final List items;
  final CartController cartController;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  const MenuGrid({
    super.key,
    required this.items,
    required this.cartController,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.76,
    this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
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