import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/role_service.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        0,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.textGreyLight,
                ),
              ),

              const Text(
                'Mau Pesan Apa?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:
                      AppColors.textBlack,
                ),
              ),
            ],
          ),

          Row(
            children: [
              if (RoleService.isAdmin)
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.addMenu,
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryRed,
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color:
                          AppColors.textWhite,
                    ),
                  ),
                ),

              if (RoleService.isAdmin)
                const SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.profile,
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.bgGrey,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color:
                        AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}