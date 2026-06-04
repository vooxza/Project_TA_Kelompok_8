import 'package:flutter/material.dart';

class AppColors {
  // Primary Color
  static const Color primaryRed = Color(0xFFB71C1C);
  static const Color primaryRedDark = Color(0xFF6D1212);
  static const Color primaryRedLight = Color(0xFFBF2626);
  
  // Background Colors
  static const Color bgGrey = Color(0xFFF0F0F0);
  static const Color bgGreyLight = Color(0xFFE8E8E8);
  static const Color bgGreyDark = Color(0xFFD0D0D0);
  static const Color bgCream = Color(0xFFFFF8F3);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFF5EDE6);
  static const Color bgSurfaceLight = Color(0xFFFAF3EE);
  static const Color bgDark = Color(0xFF1A0A0A);
  
  // Text Colors
  static const Color textBlack = Colors.black;
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.grey;
  static const Color textGreyLight = Color(0xFF999999);
  static const Color textDark = Color(0xFF1A0A0A);
  static const Color textMedium = Color(0xFF5C3D2E);
  static const Color textLight = Color(0xFF9C7B6B);
  static const Color textCream = Color(0xFFFFF8F3);
  
  // Accent Colors
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color accentRedLight = Color(0xFFEF5350);
  static const Color accentGold = Color(0xFFE8962A);
  static const Color accentGoldLight = Color(0xFFF5B94E);
  static const Color accentGoldSoft = Color(0xFFFFF0D6);
  
  // Semantic Colors
  static const Color success = Color(0xFF2D8B4E);
  static const Color successLight = Color(0xFFE8F5ED);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFE8962A);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF1565C0);


  // Border & Divider Colors
  static const Color borderLight = Color(0xFFEDE0D8);
  static const Color borderMedium = Color(0xFFD4B8AA);
  static const Color divider = Color(0xFFF0E4DC);

  // Shadow Colors
  static const Color shadowWarm = Color(0x1A9B1B1B);
  static const Color shadowDark = Color(0x0F1A0A0A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9B1B1B), Color(0xFF6D1212)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFF9B1B1B), Color(0xFFBF2626), Color(0xFFE8962A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient creamGradient = LinearGradient(
    colors: [Color(0xFFFFF8F3), Color(0xFFF5EDE6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Color(0x00000000), Color(0xCC1A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
