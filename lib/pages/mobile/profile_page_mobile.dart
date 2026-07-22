import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/profile/info_card_mobile.dart';
import '../../widgets/profile/logout_button_mobile.dart';
import '../../widgets/profile/profile_header_mobile.dart';
import '../../core/theme/app_colors.dart';

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
