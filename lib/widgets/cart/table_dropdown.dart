import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../controllers/cart_controller.dart';

class TableDropdown extends StatelessWidget {
  final CartController controller;

  const TableDropdown({
    super.key,
    required this.controller,
  });

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Obx(
        () => DropdownButton<String>(
          value: controller.selectedTable.value,
          isExpanded: true,
          hint: const Text(
            "Pilih Nomor Meja",
          ),
          underline: const SizedBox(),
          borderRadius: BorderRadius.circular(18),
          items: mejaList.map((table) {
            return DropdownMenuItem(
              value: table,
              child: Text(table),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedTable.value = value;
          },
        ),
      ),
    );
  }
}