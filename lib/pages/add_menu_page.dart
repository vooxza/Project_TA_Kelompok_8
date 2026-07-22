import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_menu_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/add_menu_page_mobile.dart';
import 'wide/add_menu_page_wide.dart';

class AddMenuPage extends GetView<AddMenuController> {
  const AddMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: AddMenuPageMobile(),
      wide: AddMenuPageWide(),
    );
  }
}
