import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import '../core/theme/app_colors.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
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

    Get.snackbar(
      'Logout!',
       'Berhasil keluar dari akun',
        backgroundColor: AppColors.primaryRed,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
        icon: const Icon(
        Icons.logout_rounded,
        color: Colors.white,
         size: 20,
      ),
    );

    Get.offAllNamed(AppRoutes.start);
  }
}
