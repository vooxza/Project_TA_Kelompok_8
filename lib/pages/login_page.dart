import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/controllers/login_controller.dart';
import 'package:project_ta_kelompok_8/core/theme/app_colors.dart';
import 'package:project_ta_kelompok_8/widgets/login/custom_login_button.dart';
import 'package:project_ta_kelompok_8/widgets/login/custom_login_input.dart';
import 'package:project_ta_kelompok_8/widgets/login/login_bottom_sheet.dart';
import 'package:project_ta_kelompok_8/widgets/login/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: Get.back,

      child: const Scaffold(
        body: _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return GestureDetector(
      onTap: () {},

      child: LoginBottomSheet(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoginHeader(),

            const SizedBox(height: 28),

            CustomLoginInput(
              controller: controller.emailController,
              hint: 'Email',
              keyboardType:
                  TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            CustomLoginInput(
              controller:
                  controller.passwordController,
              hint: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 20),

            Obx(
              () => controller
                      .errorMessage.value.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: AppColors.warning,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            Obx(
              () => CustomLoginButton(
                text: 'Masuk',
                isLoading:
                    controller.isLoading.value,
                onTap: controller.login,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}