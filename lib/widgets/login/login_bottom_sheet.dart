import 'package:flutter/material.dart';
import 'package:project_ta_kelompok_8/core/theme/app_colors.dart';

class LoginBottomSheet extends StatelessWidget {
  final Widget child;

  const LoginBottomSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }
}