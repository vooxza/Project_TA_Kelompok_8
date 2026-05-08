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

      box.write('token', token);
      box.write('user', user);
      box.write('name', user['name']);
      box.write('email', user['email']);
      box.write('role', user['role']);

      Get.snackbar(
        'Sukses',
        'Login berhasil',
        snackPosition: SnackPosition.TOP,
      );

      // ✅ Redirect berdasarkan role
      final role = user['role'] as String;
      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }

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