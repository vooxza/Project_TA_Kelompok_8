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
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused ? AppColors.primaryRed : AppColors.borderLight,
            width: 1.5,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: controller.searchController,
          focusNode: _focusNode,
          onChanged: (value) => controller.searchQuery.value = value,
          onTapOutside: (_) => _focusNode.unfocus(),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.primaryRed,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.search_rounded,
                color: _isFocused ? AppColors.primaryRed : AppColors.textLight,
                size: 20,
              ),
            ),
            suffixIcon: Obx(() {
              if (controller.searchQuery.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () {
                  controller.searchController.clear();
                  controller.searchQuery.value = '';
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textLight,
                  size: 18,
                ),
              );
            }),
            hintText: 'Cari menu favorit kamu...',
            hintStyle: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}