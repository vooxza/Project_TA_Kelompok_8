import 'package:flutter/material.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/splashscreen_mobile.dart';
import 'wide/splashscreen_wide.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: SplashScreenMobile(),
      wide: SplashScreenWide(),
    );
  }
}
