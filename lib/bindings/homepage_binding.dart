import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/homepage_controller.dart';
import 'package:project_ta_kelompok_8/controllers/menu_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(
      () => HomePageController(),
      fenix: true, // Re-create if deleted
    );
    Get.lazyPut<MenuController>(
      () => MenuController(),
      fenix: true, // Re-create if deleted
    );
  }
}