import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/menu_page_mobile.dart';
import 'wide/menu_page_wide.dart';

class MenuPage extends GetView<MenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: MenuPageMobile(),
      wide: MenuPageWide(),
    );
  }
}
