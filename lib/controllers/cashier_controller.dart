import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../core/services/api_service.dart';

class CashierController extends GetxController {
  final ApiService _api = ApiService();

  final users = <UserModel>[].obs;
  final isLoading = false.obs;
  final loadError = RxnString();
  final searchQuery = ''.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State Dropdown Status
  var selectedRole = 'user'.obs;
  var selectedStatus = 'active'.obs;

  List<UserModel> get filteredUsers {
    if (searchQuery.value.isEmpty) return users;
    final q = searchQuery.value.toLowerCase();
    return users.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    selectedRole.value = 'cashier';
    selectedStatus.value = 'active';
  }

  void populateForm(UserModel user) {
    nameController.text = user.name;
    emailController.text = user.email;
    passwordController.clear();
    selectedRole.value = user.role.isEmpty ? 'cashier' : user.role;
    
    // Normalisasi status dari backend ke 'active' / 'inactive'
    final statusVal = user.status?.toString().toLowerCase();
    if (statusVal == 'inactive' || statusVal == '0' || statusVal == 'false' || user.status == false) {
      selectedStatus.value = 'inactive';
    } else {
      selectedStatus.value = 'active';
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      loadError.value = null;
      final result = await _api.getUsers();
      users.assignAll(result);
    } catch (e) {
      loadError.value =
          'Data akun kasir tidak dapat dimuat saat ini. Periksa koneksi internet lalu coba lagi.';
    } finally {
      isLoading(false);
    }
  }

  Future<void> createUser() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Semua field wajib diisi');
      return;
    }

    try {
      isLoading(true);
      await _api.createUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: 'user', // Atau 'cashier' (samakan dengan role kasir lama di DB)
      );
      Get.back();
      clearForm();
      await fetchUsers();
      Get.snackbar('Berhasil', 'Akun kasir berhasil dibuat');
    } catch (e) {
      Get.snackbar('Gagal', 'Akun kasir tidak dapat dibuat: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUser(UserModel user) async {
  try {
    isLoading(true);

    // Pengecekan status jadi sangat simpel karena status di UserModel sudah bernilai String konsisten ('active' / 'inactive')
    final isCurrentlyActive = user.status == 'active';
    final targetActive = selectedStatus.value == 'active';

    // Jika status di dropdown beda dengan status user saat ini, panggil API toggle
    if (targetActive != isCurrentlyActive) {
      await _api.toggleUserStatus(user.id!);
    }

    Get.back();
    clearForm();
    await fetchUsers(); // Refresh list data dari server
    Get.snackbar('Berhasil', 'Status kasir berhasil diperbarui');
  } catch (e) {
    Get.snackbar('Gagal', 'Gagal memperbarui status: $e');
  } finally {
    isLoading(false);
  }
}

  Future<void> toggleUserStatus(UserModel user) async {
    final label = user.status == 'active' ? 'dinonaktifkan' : 'diaktifkan';

    try {
      isLoading(true);
      await _api.toggleUserStatus(user.id!);
      Get.snackbar('Berhasil', 'Akun ${user.name} berhasil $label');
      await fetchUsers();
    } catch (e) {
      Get.snackbar('Gagal', 'Status akun tidak dapat diubah: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isLoading(true);
      await _api.deleteUser(id); // Hapus permanen via API DELETE
      await fetchUsers(); // Refresh daftar kasir
      Get.snackbar('Berhasil', 'Akun berhasil dihapus permanen');
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menghapus akun: $e');
    } finally {
      isLoading(false);
    }
  }
}