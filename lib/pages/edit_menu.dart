import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/image_picker_box.dart';
import '../controllers/edit_menu_controller.dart';
import '../theme/colors.dart';

class EditMenuPage extends GetView<EditMenuController> {
  const EditMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Menu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 30,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// IMAGE
            Obx(() => ImagePickerBox(
                  imagePath: controller.selectedImage.value,
                  onTap: controller.pickImageFromGallery,
                )),

            const SizedBox(height: 15),

            /// BUTTON GANTI GAMBAR
            CustomButton(
              text: "Ganti Gambar",
              onTap: controller.pickImageFromGallery,
            ),

            const SizedBox(height: 25),

            /// INPUT NAMA
            CustomInput(
              controller: controller.nameController,
              label: "Nama",
              hint: "Nama menu",
            ),

            const SizedBox(height: 15),

            /// DROPDOWN CATEGORY
            Obx(() => CustomDropdown<int>(
                  label: "Category",
                  value: controller.selectedCategoryId.value,
                  items: controller.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      controller.selectedCategoryId.value = value,
                )),

            const SizedBox(height: 15),

            /// INPUT HARGA
            CustomInput(
              controller: controller.priceController,
              label: "Harga",
              hint: "Harga menu",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 30),

            /// BUTTON SIMPAN
            CustomButton(
              text: "Simpan",
              onTap: controller.saveMenu,
            ),

            const SizedBox(height: 20),

            /// BUTTON DELETE
            CustomButton(
              text: "Hapus Menu",
              color: AppColors.error,
              onTap: controller.deleteMenu,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}