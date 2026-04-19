import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../routes/routes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Search bar and Profile
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                onPressed: () => Get.offNamed(AppRoutes.profile),
                icon: const Icon(
                  Icons.account_circle_outlined,
                  size: 32,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Welcome Text
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome!",
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Mau Pesan Apa?",
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
