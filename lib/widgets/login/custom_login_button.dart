import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  const CustomLoginButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Color(0xFFFF8A80),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.textWhite,
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}