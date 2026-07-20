import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/menu/add & edit/custom_input.dart';
import '../../widgets/menu/add & edit/custom_button.dart';
import '../../widgets/menu/add & edit/custom_dropdown.dart';
import '../../widgets/menu/add & edit/image_picker_box.dart';
import '../../controllers/edit_menu_controller.dart';
import '../../core/theme/app_colors.dart';

/// Versi mobile dari EditMenuPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `edit_menu_page.dart` cuma jadi switcher tipis.
class EditMenuPageMobile extends GetView<EditMenuController> {
  const EditMenuPageMobile();

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

            CustomInput(
              controller: controller.descriptionController,
              label: "Deskripsi",
              hint: "Deskripsi menu (opsional)",
              maxLines: 3,
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
              numberOnly: true,
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