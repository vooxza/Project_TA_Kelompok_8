import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/payment_page_mobile.dart';
import 'wide/payment_page_wide.dart';

class PaymentPage extends GetView<CartController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: PaymentPageMobile(),
      wide: PaymentPageWide(),
    );
  }
}
