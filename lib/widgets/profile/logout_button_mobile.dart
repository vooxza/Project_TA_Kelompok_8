import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Tombol keluar (logout) untuk halaman Profil mobile.
class LogoutButtonMobile extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutButtonMobile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 20,
            ),
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
    );
  }
}
