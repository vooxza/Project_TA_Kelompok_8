import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan fenix: true agar controller tidak mati saat navigasi bolak-balik
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
