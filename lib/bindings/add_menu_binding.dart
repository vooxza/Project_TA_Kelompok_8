import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/add_menu_controller.dart';
import 'package:project_ta_kelompok_8/controllers/menu_controller.dart';

class AddMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuController>(() => MenuController());
    Get.lazyPut<AddMenuController>(() => AddMenuController());
  }
}
