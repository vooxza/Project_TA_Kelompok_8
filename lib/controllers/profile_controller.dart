import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import 'bottomnav_controller.dart';
import 'cart_controller.dart';
import 'menu_controller.dart';
import 'history_controller.dart';

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

    // 2. Reset controller yang sifatnya global/permanent (dibuat sekali di
    // main.dart & tidak pernah di-dispose), supaya user berikutnya yang
    // login (misal admin -> kasir) tidak mewarisi tab aktif & isi
    // keranjang dari sesi sebelumnya.
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().goToForce(0);
    }
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clearCart();
    }
    // Reset pencarian & filter kategori Menu supaya user berikutnya
    // (misal admin -> kasir) tidak mewarisi pencarian/filter sesi lama.
    if (Get.isRegistered<MenuController>()) {
      final menuController = Get.find<MenuController>();
      menuController.searchQuery.value = '';
      menuController.searchController.clear();
      menuController.selectedCategoryId.value = null;
    }
    // Reset filter tanggal/bulan di Riwayat Pesanan dengan alasan yang sama.
    if (Get.isRegistered<HistoryController>()) {
      final historyController = Get.find<HistoryController>();
      historyController.selectedTable.value = null;
      historyController.selectedDate.value = null;
      historyController.selectedMonthFilter.value = null;
    }

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
