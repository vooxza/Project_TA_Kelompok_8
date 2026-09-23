import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cashier_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';

class CashierPageMobile extends GetView<CashierController> {
  const CashierPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Manajemen Kasir',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_add_rounded,
                  color: Colors.white, size: 20),
            ),
            onPressed: () => _showCashierForm(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      size: 20, color: AppColors.textLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => controller.searchQuery.value = v,
                      decoration: const InputDecoration(
                        hintText: 'Cari kasir...',
                        hintStyle: TextStyle(
                            color: AppColors.textLight, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                          color: AppColors.textDark, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryRed, strokeWidth: 2.5),
                );
              }

              if (controller.loadError.value != null) {
                return _CashierErrorState(
                  message: controller.loadError.value!,
                  onRetry: controller.fetchUsers,
                );
              }

              final users = controller.filteredUsers;
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline_rounded,
                          size: 56, color: AppColors.textLight.withOpacity(0.4)),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada akun kasir',
                        style: TextStyle(
                            fontSize: 15, color: AppColors.textMedium),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: users.length,
                itemBuilder: (context, index) =>
                    _CashierTile(user: users[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCashierForm(BuildContext context, {UserModel? user}) {
    if (user != null) {
      controller.populateForm(user);
    } else {
      controller.clearForm();
    }

    Get.bottomSheet(
      _CashierFormSheet(user: user),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _CashierErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _CashierErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: AppColors.textLight.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textMedium),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CashierTile extends StatelessWidget {
  final UserModel user;
  const _CashierTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status != 'inactive';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryRed.withOpacity(0.1)
                  : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.person_rounded,
                size: 22,
                color: isActive ? AppColors.primaryRed : AppColors.textLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textLight),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: user.role == 'admin'
                            ? AppColors.primaryRed.withOpacity(0.1)
                            : AppColors.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.role == 'admin' ? 'ADMIN' : 'KASIR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: user.role == 'admin'
                              ? AppColors.primaryRed
                              : const Color(0xFF8A6D1D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.successLight
                            : AppColors.errorLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color:
                              isActive ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.more_vert_rounded,
                  size: 18, color: AppColors.textMedium),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'edit') {
                _editCashier(context);
              } else if (value == 'toggle') {
                _toggleStatus();
              } else if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, size: 18, color: AppColors.textMedium),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      isActive
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      size: 18,
                      color: isActive ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 10),
                    Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.error),
                    SizedBox(width: 10),
                    Text('Hapus', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editCashier(BuildContext context) {
    final controller = Get.find<CashierController>();
    controller.populateForm(user);
    Get.bottomSheet(
      _CashierFormSheet(user: user),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _toggleStatus() {
    final controller = Get.find<CashierController>();
    controller.toggleUserStatus(user);
  }

  void _confirmDelete(BuildContext context) {
    final controller = Get.find<CashierController>();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Akun',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Hapus akun "${user.name}" secara permanen?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMedium)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(user.id!);
            },
            child: const Text('Hapus',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CashierFormSheet extends StatelessWidget {
  final UserModel? user;
  const _CashierFormSheet({this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();
    final isEdit = user != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isEdit ? 'Edit Akun Kasir' : 'Tambah Akun Kasir',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 20),
            _buildField('Nama', controller.nameController,
                Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _buildField('Email', controller.emailController,
                Icons.email_outlined,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _buildField(
              isEdit ? 'Password (kosongkan jika tidak ubah)' : 'Password',
              controller.passwordController,
              Icons.lock_outline_rounded,
              obscure: true,
            ),
            const SizedBox(height: 14),

            // Dropdown Status Akun Mobile Sheet
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status Akun',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMedium)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: controller.selectedStatus.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.toggle_on_outlined,
                            size: 20, color: AppColors.textLight),
                        filled: true,
                        fillColor: AppColors.bgCream,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primaryRed, width: 1.5),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'active', child: Text('Active / Aktif'))
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          controller.selectedStatus.value = val;
                        }
                      },
                    ),
                  ],
                )),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (isEdit) {
                    controller.updateUser(user!);
                  } else {
                    controller.createUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  isEdit ? 'Simpan Perubahan' : 'Buat Akun',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.textLight),
            hintText: 'Masukkan $label',
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
            filled: true,
            fillColor: AppColors.bgCream,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
          ),
          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
        ),
      ],
    );
  }
}