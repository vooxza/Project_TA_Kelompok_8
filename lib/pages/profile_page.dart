import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER CUSTOM (Back Button & Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Get.back(), // Navigasi balik ke Homepage
                  ),
                  const Expanded(
                    child: Text(
                      "PROFILE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ), // Penyeimbang agar title tetap di tengah
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      /// FOTO PROFIL (Lingkaran Abu-abu)
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 6,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 90,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// NAMA USER (DINAMIS)
                      Obx(
                        () => Text(
                          controller.userName.value.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      /// EMAIL (Optional tambahan agar profil tidak terlalu sepi)
                      Obx(
                        () => Text(
                          controller.userEmail.value,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// BUTTON RIWAYAT PESANAN
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => Get.toNamed(AppRoutes.history),
                          child: const Text(
                            "Riwayat Pesanan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// BUTTON KELUAR (Tetap di posisi bawah)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryRed,
                    side: const BorderSide(
                      color: AppColors.primaryRed,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => controller.logout(),
                  child: const Text(
                    "Keluar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
