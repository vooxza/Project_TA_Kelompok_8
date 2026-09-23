import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cashier_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../widgets/common/wide_page_container.dart';

class CashierPageWide extends GetView<CashierController> {
  const CashierPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textDark),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Manajemen Kasir',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              // Search Field
              Container(
                width: 260,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 18, color: AppColors.textLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => controller.searchQuery.value = v,
                        decoration: const InputDecoration(
                          hintText: 'Cari kasir...',
                          hintStyle: TextStyle(
                              color: AppColors.textLight, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(
                            color: AppColors.textDark, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Add Button
              GestureDetector(
                onTap: () => _showCashierForm(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_add_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Kasir',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Nama', style: _headerStyle)),
                Expanded(flex: 3, child: Text('Email', style: _headerStyle)),
                SizedBox(width: 12),
                SizedBox(width: 70, child: Text('Role', style: _headerStyle)),
                SizedBox(width: 12),
                SizedBox(width: 70, child: Text('Status', style: _headerStyle)),
                SizedBox(width: 80, child: Text('Aksi', style: _headerStyle)),
              ],
            ),
          ),
          const SizedBox(height: 8),

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
                          size: 56,
                          color: AppColors.textLight.withOpacity(0.4)),
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
                itemCount: users.length,
                itemBuilder: (context, index) =>
                    _CashierRow(user: users[index]),
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

    Get.dialog(
      Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _CashierFormDialog(user: user),
        ),
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: AppColors.textMedium,
  letterSpacing: 0.3,
);

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

class _CashierRow extends StatelessWidget {
  final UserModel user;
  const _CashierRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final statusVal = user.status?.toString().toLowerCase();
    final isActive = statusVal == 'active' || 
                    statusVal == '1' || 
                    statusVal == 'true' || 
                    user.status == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryRed.withOpacity(0.1)
                        : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person_rounded,
                      size: 18,
                      color: isActive
                          ? AppColors.primaryRed
                          : AppColors.textLight),
                ),
                const SizedBox(width: 10),
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(user.email,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textMedium)),
          ),
          SizedBox(
            width: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: user.role == 'admin'
                    ? AppColors.primaryRed.withOpacity(0.1)
                    : AppColors.accentGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.role == 'admin' ? 'Admin' : 'Kasir',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: user.role == 'admin'
                      ? AppColors.primaryRed
                      : const Color(0xFF8A6D1D),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isActive ? AppColors.successLight : AppColors.errorLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isActive ? 'Aktif' : 'Nonaktif',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: PopupMenuButton<String>(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.more_vert_rounded,
                    size: 16, color: AppColors.textMedium),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                final ctrl = Get.find<CashierController>();
                if (value == 'edit') {
                  ctrl.populateForm(user);
                  Get.dialog(
                    Align(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: _CashierFormDialog(user: user),
                      ),
                    ),
                  );
                } else if (value == 'toggle') {
                  ctrl.toggleUserStatus(user);
                } else if (value == 'delete') {
                  _confirmDelete(context, ctrl);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded,
                          size: 16, color: AppColors.textMedium),
                      SizedBox(width: 8),
                      Text('Edit', style: TextStyle(fontSize: 13)),
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
                        size: 16,
                        color: isActive ? AppColors.error : AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text(isActive ? 'Nonaktifkan' : 'Aktifkan',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 16, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Hapus',
                          style:
                              TextStyle(fontSize: 13, color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CashierController ctrl) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Akun',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Hapus akun "${user.name}" secara permanen?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textMedium)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              ctrl.deleteUser(user.id!);
            },
            child: const Text('Hapus',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CashierFormDialog extends StatelessWidget {
  final UserModel? user;
  const _CashierFormDialog({this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();
    final isEdit = user != null;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Akun Kasir' : 'Tambah Akun Kasir',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark),
              ),
              const SizedBox(height: 24),
              _buildField('Nama', controller.nameController,
                  Icons.person_outline_rounded),
              const SizedBox(height: 16),
              _buildField('Email', controller.emailController,
                  Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildField(
                isEdit ? 'Password (kosongkan jika tidak ubah)' : 'Password',
                controller.passwordController,
                Icons.lock_outline_rounded,
                obscure: true,
              ),
              const SizedBox(height: 16),
              
              // Dropdown Status Akun
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

              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal',
                            style: TextStyle(
                                color: AppColors.textMedium,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
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
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isEdit ? 'Simpan' : 'Buat Akun',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
            hintStyle:
                const TextStyle(color: AppColors.textLight, fontSize: 14),
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