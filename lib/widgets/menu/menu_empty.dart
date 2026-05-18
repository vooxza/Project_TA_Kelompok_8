import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MenuEmpty extends StatelessWidget {
  const MenuEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tidak ada menu tersedia',
        style: TextStyle(
          color: AppColors.textGreyLight,
        ),
      ),
    );
  }
}