import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/pages/homepage.dart';
import 'package:project_ta_kelompok_8/pages/menu_page.dart';
import 'package:project_ta_kelompok_8/pages/keranjang_page.dart';
import 'package:project_ta_kelompok_8/pages/startingscreen.dart';
import 'package:project_ta_kelompok_8/pages/splashscreen.dart';
import 'package:project_ta_kelompok_8/routes/routes.dart';

import '../bindings/homepage_binding.dart';
import '../bindings/splashscreen_binding.dart';
import '../bindings/startingscreen_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashscreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.start,
      page: () => StartingScreen(),
      binding: StartingScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.homepage,
      page: () => HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: AppRoutes.menu,
      page: () => MenuPage(),
    ),
    GetPage(
      name: AppRoutes.keranjang,
      page: () => CartPage(),
    ),
  ];
}
