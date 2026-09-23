import 'dart:convert';
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
    if (emailController.text.trim().isEmpty || 
        passwordController.text.trim().isEmpty) {
      errorMessage.value = 'Email dan password wajib diisi!';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = response['user'];
      final bool isActive = user['is_active'] ?? true;

      // Proteksi tambahan jika akun nonaktif
      if (!isActive) {
        const inactiveMsg = 'Akun Anda telah dinonaktifkan. Silakan hubungi admin.';
        errorMessage.value = inactiveMsg;
        _showErrorSnackbar(inactiveMsg);
        return;
      }

      final token = response['access_token'] ?? response['token'];

      // Simpan credential ke GetStorage
      box.write('token', token);
      box.write('user', user);
      box.write('name', user['name']);
      box.write('email', user['email']);
      box.write('role', user['role']);

      Get.offAllNamed(AppRoutes.main);

    } catch (e) {
      final cleanMsg = _parseErrorMessage(e.toString());
      errorMessage.value = cleanMsg;
      _showErrorSnackbar(cleanMsg);
    } finally {
      isLoading.value = false;
    }
  }

  // Helper untuk mengekstrak pesan 'message' asli dari response backend
  String _parseErrorMessage(String rawError) {
    if (rawError.contains('{"message":')) {
      try {
        final startIndex = rawError.indexOf('{"message":');
        final jsonStr = rawError.substring(startIndex);
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map && decoded.containsKey('message')) {
          return decoded['message'].toString();
        }
      } catch (_) {}
    }

    // Fallback jika berupa string teks biasa/HTTP Exception
    String clean = rawError.replaceAll(
      RegExp(r'Exception:|Error:|Failed to post data:|\d{3}\s*-'), 
      ''
    ).trim();

    return clean.isNotEmpty ? clean : 'Gagal terhubung ke server.';
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Akses Ditolak',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.block, color: Colors.white),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}