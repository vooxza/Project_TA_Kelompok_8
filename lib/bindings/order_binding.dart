import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
