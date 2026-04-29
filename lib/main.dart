import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/pages.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'controllers/bottomnav_controller.dart';
import 'controllers/cart_controller.dart';

void main() async {
  Get.put(BottomNavController());
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soto Mbok Kerso',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splashscreen,
      getPages: AppPages.pages,
    );
  }
}
