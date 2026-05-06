import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/bindings/profile_binding.dart';
import 'package:project_ta_kelompok_8/pages/history_page.dart';
import 'package:project_ta_kelompok_8/pages/login_page.dart';
import 'package:project_ta_kelompok_8/pages/home_page.dart';
import 'package:project_ta_kelompok_8/pages/menu_page.dart';
import 'package:project_ta_kelompok_8/pages/edit_menu_page.dart';
import 'package:project_ta_kelompok_8/pages/add_menu_page.dart';
import 'package:project_ta_kelompok_8/pages/cart_page.dart';
import 'package:project_ta_kelompok_8/pages/payment_page.dart';
import 'package:project_ta_kelompok_8/pages/profile_page.dart';
import 'package:project_ta_kelompok_8/pages/splashscreen.dart';
import 'package:project_ta_kelompok_8/pages/startingscreen.dart';
import 'package:project_ta_kelompok_8/routes/app_routes.dart';

import 'package:project_ta_kelompok_8/bindings/history_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/homepage_binding.dart';
import '../bindings/menu_binding.dart';
import '../bindings/edit_menu_binding.dart';
import '../bindings/add_menu_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/splashscreen_binding.dart';
import '../bindings/startingscreen_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashscreen,
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.start,
      page: () => StartingScreen(),
      binding: StartingScreenBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.homepage,
      page: () => HomePage(),
      binding: HomePageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.menu,
      page: () => MenuPage(),
      binding: MenuBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.editMenu,
      page: () => EditMenuPage(),
      binding: EditMenuBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addMenu,
      page: () => AddMenuPage(),
      binding: AddMenuBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => CartPage(),
      binding: CartBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => HistoryPage(),
      binding: HistoryBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
