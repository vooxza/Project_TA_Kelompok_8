import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/pages/homepage.dart';
import 'package:project_ta_kelompok_8/pages/splashscreen.dart';
import 'package:project_ta_kelompok_8/routes/routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splashscreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => Homepage())
  ];
}
  