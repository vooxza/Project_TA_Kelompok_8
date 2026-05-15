import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/history_controller.dart';
import '../controllers/bottomnav_controller.dart';
import '../controllers/homepage_controller.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<HomePageController>(() => HomePageController(), fenix: true);
    Get.lazyPut<MenuController>(() => MenuController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}