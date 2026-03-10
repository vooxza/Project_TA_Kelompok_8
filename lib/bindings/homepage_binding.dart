import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/homepage_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
  }
}