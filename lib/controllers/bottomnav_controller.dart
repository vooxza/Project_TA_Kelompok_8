import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/routes/routes.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final routes = [
    AppRoutes.homepage,
    AppRoutes.menu,
    AppRoutes.cart,
  ];

  void goTo(int index) {
    if (currentIndex.value == index) return;

    currentIndex.value = index;
    Get.offNamed(routes[index]);
  }
}