import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_ta_kelompok_8/routes/app_routes.dart';
import 'package:project_ta_kelompok_8/core/services/api_service.dart';

class LoginController extends GetxController {
  final ApiService apiService = ApiService();
  final box = GetStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Email dan password wajib diisi';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      final token = response['access_token'];
      final user = response['user'];

      // Simpan semua data session
      box.write('token', token);
      box.write('user', user);
      box.write('name', user['name']);   // ✅ untuk ProfileController
      box.write('email', user['email']); // ✅ untuk ProfileController
      box.write('role', user['role']);   // ✅ simpan role juga kalau ada

      print('TOKEN TERSIMPAN: $token');
      print('LOGIN RESPONSE: $response');

      Get.snackbar(
        'Sukses',
        'Login berhasil',
        snackPosition: SnackPosition.TOP,
      );

      Get.offAllNamed(AppRoutes.main);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}