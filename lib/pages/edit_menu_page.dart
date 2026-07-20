import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_menu_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/edit_menu_page_mobile.dart';
import 'wide/edit_menu_page_wide.dart';

class EditMenuPage extends GetView<EditMenuController> {
  const EditMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: EditMenuPageMobile(),
      wide: EditMenuPageWide(),
    );
  }
}
