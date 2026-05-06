import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../controllers/cart_controller.dart';

class TableDropdown extends StatelessWidget {
  final CartController controller;

  const TableDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final mejaList = [
      "Meja 1",
      "Meja 2",
      "Meja 3",
      "Meja 4",
      "Meja 5",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bgGreyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => DropdownButton<String>(
          isExpanded: true,
          value: controller.selectedTable.value,
          hint: const Text("Pilih Nomor Meja"),
          underline: const SizedBox(),
          items: mejaList
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (value) =>
              controller.selectedTable.value = value,
        ),
      ),
    );
  }
}