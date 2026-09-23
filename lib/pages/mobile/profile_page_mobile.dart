import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../core/services/role_service.dart';
import '../../widgets/profile/info_card_mobile.dart';
import '../../widgets/profile/logout_button_mobile.dart';
import '../../widgets/profile/profile_header_mobile.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

/// Versi mobile dari ProfilePage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `profile_page.dart` cuma jadi switcher tipis.
class ProfilePageMobile extends GetView<ProfileController> {
  const ProfilePageMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: Column(
        children: [
          // Hero header
          ProfileHeaderMobile(controller: controller),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  InfoCardMobile(controller: controller),
                  const SizedBox(height: 24),
                  if (RoleService.isAdmin) ...[
                    _AdminMenuButton(
                      icon: Icons.people_rounded,
                      label: 'Manajemen Kasir',
                      onTap: () => Get.toNamed(AppRoutes.cashierManagement),
                    ),
                    const SizedBox(height: 12),
                  ],
                  LogoutButtonMobile(onTap: controller.logout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AdminMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primaryRed),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 22, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
