import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'USER'.obs;
  final userEmail = 'user@gmail.com'.obs;
  final userPhone = '08xxxxxxxxxx'.obs;

  void logout() {
    // Add logout logic here
    Get.snackbar('Logout', 'Anda telah logout');
  }

  @override
  void onInit() {
    super.onInit();
    // Load user data here
  }

  @override
  void onClose() {
    super.onClose();
  }
}
