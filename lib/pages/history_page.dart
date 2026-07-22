import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../core/responsive/responsive_layout.dart';
import 'mobile/history_page_mobile.dart';
import 'wide/history_page_wide.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: HistoryPageMobile(),
      wide: HistoryPageWide(),
    );
  }
}
