import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/profile_page_mobile.dart';
import 'wide/profile_page_wide.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ProfilePageMobile(),
      wide: ProfilePageWide(),
    );
  }
}
