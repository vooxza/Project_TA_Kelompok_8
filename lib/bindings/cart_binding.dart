import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}
