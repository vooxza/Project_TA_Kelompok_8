import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_button.dart';
import '../widgets/image_picker_box.dart';
import '../controllers/add_menu_controller.dart';

class AddMenuPage extends GetView<AddMenuController> {
  const AddMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Menu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(
              () => ImagePickerBox(
                imagePath: controller.selectedImage.value,
                onTap: controller.pickImageFromGallery,
              ),
            ),

            const SizedBox(height: 20),

            CustomInput(
              controller: controller.nameController,
              label: "Nama",
              hint: "Nama menu",
            ),

            const SizedBox(height: 15),

            Obx(() {
              return CustomDropdown<int>(
                label: "Category",
                value: controller.selectedCategoryId.value,
                items: controller.categories.map((cat) {
                  return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                }).toList(),
                onChanged: (value) {
                  controller.selectedCategoryId.value = value;
                },
              );
            }),

            const SizedBox(height: 15),

            CustomInput(
              controller: controller.priceController,
              label: "Harga",
              hint: "Harga",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 25),

            CustomButton(text: "Simpan", onTap: controller.addMenu),
          ],
        ),
      ),
    );
  }
}
