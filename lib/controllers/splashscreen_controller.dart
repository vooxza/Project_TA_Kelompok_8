import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  RxDouble progress = 0.0.obs;

  void startAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      progress.value = 1.0;
      // Navigation is handled in the view
    });
  }

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
