import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_ta_kelompok_8/core/theme/app_colors.dart';
import 'package:project_ta_kelompok_8/routes/app_routes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read('name') ?? 'User';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BARIS SEARCH & PROFILE ---
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // ✅ Icon profile dengan GestureDetector
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.profile),
                    child: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // --- TEKS WELCOME ---
              Text(
                "Welcome, $name!",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              // --- TEKS MAU PESAN APA ---
              const Text(
                "Mau Pesan Apa?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}