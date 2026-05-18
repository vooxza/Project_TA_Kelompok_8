import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../controllers/menu_controller.dart';
import '../../core/theme/app_colors.dart';

class MenuSearch extends StatefulWidget {
  const MenuSearch({super.key});

  @override
  State<MenuSearch> createState() => _MenuSearchState();
}

class _MenuSearchState extends State<MenuSearch> {
  final MenuController controller = Get.find<MenuController>();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.unfocus(); // ← unfocus saat widget di-dispose (navigasi keluar)
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextField(
          controller: controller.searchController,
          focusNode: _focusNode, // ← pakai focusNode ini

          onChanged: (value) {
            controller.searchQuery.value = value;
          },

          onTapOutside: (_) {
            _focusNode.unfocus(); // ← unfocus pakai focusNode sendiri
          },

          cursorColor: AppColors.primaryRed,

          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textBlack,
            fontWeight: FontWeight.w500,
          ),

          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGrey),
            hintText: 'Cari menu...',
            hintStyle: TextStyle(
              color: AppColors.textGreyLight,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}