import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  // Observables untuk data user
  var userName = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Mengambil nama dan email dari storage yang disimpan saat login
    // Jika data kosong, default ke 'User'
    userName.value = box.read('name') ?? 'User';
    userEmail.value = box.read('email') ?? '-';
  }

  void logout() {
    // 1. Hapus semua data session (token, role, name, dll)
    box.erase();

    // 2. Tampilkan Snackbar
    Get.snackbar(
      'Logout',
      'Berhasil keluar dari akun',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );

    // 3. Arahkan ke halaman login dan hapus semua history navigasi
    Get.offAllNamed(AppRoutes.start);
  }
}
