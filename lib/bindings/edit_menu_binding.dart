import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/edit_menu_controller.dart';

class EditMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditMenuController>(() => EditMenuController());
  }
}
