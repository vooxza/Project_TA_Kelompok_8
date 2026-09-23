import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cashier_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/cashier_page_mobile.dart';
import 'wide/cashier_page_wide.dart';

class CashierPage extends GetView<CashierController> {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: CashierPageMobile(),
      wide: CashierPageWide(),
    );
  }
}
