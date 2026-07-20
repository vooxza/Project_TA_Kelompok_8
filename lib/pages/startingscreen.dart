import 'package:flutter/material.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/startingscreen_mobile.dart';
import 'wide/startingscreen_wide.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: StartingScreenMobile(),
      wide: StartingScreenWide(),
    );
  }
}
