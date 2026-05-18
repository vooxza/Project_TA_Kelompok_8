import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void goTo(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }

  void goToForce(int index) {
    currentIndex.value = index;
  }
}