import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/profile/info_row_wide.dart';
import '../../widgets/profile/profile_identity_panel_wide.dart';

/// Versi widescreen dari ProfilePage. Fitur & data sama persis dengan versi
/// mobile (nama, email, status akun, tombol keluar) — didesain ulang jadi
/// dua kolom berdampingan (bukan ditumpuk vertikal seperti mobile) supaya
/// pas dengan proporsi layar lebar. Memakai [WidePageContainer] supaya
/// tampilannya satu kanvas cream penuh, tanpa kartu mengambang terpisah.
class ProfilePageWide extends GetView<ProfileController> {
  const ProfilePageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 900,
      child: Center(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kiri: identitas & status
              Expanded(
                flex: 4,
                child: ProfileIdentityPanelWide(controller: controller),
              ),

              // Kanan: informasi akun & aksi
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Informasi Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => InfoRowWide(
                          icon: Icons.person_outline_rounded,
                          label: 'Nama',
                          value: controller.userName.value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: 16),
                      Obx(
                        () => InfoRowWide(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: controller.userEmail.value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: 16),
                      const InfoRowWide(
                        icon: Icons.shield_outlined,
                        label: 'Status',
                        value: 'Aktif',
                        valueColor: AppColors.success,
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: controller.logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorLight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: AppColors.error, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Keluar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
