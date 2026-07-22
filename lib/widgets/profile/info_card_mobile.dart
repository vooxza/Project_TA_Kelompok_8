import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_colors.dart';
import 'info_row_mobile.dart';

/// Kartu "Informasi Akun" untuk halaman Profil mobile.
class InfoCardMobile extends StatelessWidget {
  final ProfileController controller;
  const InfoCardMobile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => InfoRowMobile(
              icon: Icons.person_outline_rounded,
              label: 'Nama',
              value: controller.userName.value,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Obx(
            () => InfoRowMobile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: controller.userEmail.value,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          const InfoRowMobile(
            icon: Icons.shield_outlined,
            label: 'Status',
            value: 'Aktif',
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}
