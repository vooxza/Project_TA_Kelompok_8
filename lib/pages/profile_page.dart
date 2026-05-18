import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../core/theme/app_colors.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileCard(),

                    const SizedBox(height: 20),

                    _buildInfoSection(),
                  ],
                ),
              ),
            ),

            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// HEADER
  /// =======================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.textWhite,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textBlack,
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
          ),

          const SizedBox(width: 42),
        ],
      ),
    );
  }

  /// =======================
  /// PROFILE CARD
  /// =======================
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 60,
              color: AppColors.primaryRed,
            ),
          ),

          const SizedBox(height: 20),

          Obx(
            () => Text(
              controller.userName.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Obx(
            () => Text(
              controller.userEmail.value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// INFO SECTION
  /// =======================
  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Nama Pengguna',
          value: controller.userName.value,
        ),

        const SizedBox(height: 14),

        _buildMenuTile(
          icon: Icons.email_outlined,
          title: 'Email',
          value: controller.userEmail.value,
        ),

        const SizedBox(height: 14),

        _buildMenuTile(
          icon: Icons.security_rounded,
          title: 'Status',
          value: 'Aktif',
        ),
      ],
    );
  }

  /// =======================
  /// MENU TILE
  /// =======================
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryRed,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// LOGOUT BUTTON
  /// =======================
  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      color: AppColors.bgGrey,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: controller.logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppColors.textWhite,
              ),

              SizedBox(width: 10),

              Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}