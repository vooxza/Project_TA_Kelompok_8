import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/login_page_mobile.dart';
import 'wide/login_page_wide.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: LoginPageMobile(),
      wide: LoginPageWide(),
    );
  }
}
