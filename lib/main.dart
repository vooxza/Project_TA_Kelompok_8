import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/thermal_print_service.dart';
import 'controllers/bottomnav_controller.dart';
import 'controllers/cart_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  ThermalPrintService.init();
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
