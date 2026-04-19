import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/menu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuController>(() => MenuController(), fenix: true);
  }
}
