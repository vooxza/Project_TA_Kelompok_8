import 'package:get/get.dart';

class StartingScreenController extends GetxController {
  RxBool isLoading = false.obs;

  void navigateToHome() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
      // Navigation is handled in the view
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
