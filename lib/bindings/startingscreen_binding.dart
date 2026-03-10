import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/startingscreen_controller.dart';

class StartingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartingScreenController>(() => StartingScreenController());
  }
}
