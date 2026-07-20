import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/cart_page_mobile.dart';
import 'wide/cart_page_wide.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: CartPageMobile(),
      wide: CartPageWide(),
    );
  }
}
