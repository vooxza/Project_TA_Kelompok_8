import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/menu/add & edit/custom_input.dart';
import '../../widgets/menu/add & edit/custom_dropdown.dart';
import '../../widgets/menu/add & edit/custom_button.dart';
import '../../widgets/menu/add & edit/image_picker_box.dart';
import '../../controllers/add_menu_controller.dart';

/// Versi mobile dari AddMenuPage. Dipisah ke file sendiri (mirip pola
/// `pages/wide/`) supaya `add_menu_page.dart` cuma jadi switcher tipis.
class AddMenuPageMobile extends GetView<AddMenuController> {
  const AddMenuPageMobile();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Gambar
            Obx(
              () => ImagePickerBox(
                imagePath: controller.selectedImage.value,
                onTap: controller.pickImageFromGallery,
              ),
            ),

            const SizedBox(height: 20),

            // Nama
            CustomInput(
              controller: controller.nameController,
              label: "Nama",
              hint: "Nama menu",
            ),

            const SizedBox(height: 15),

            // Deskripsi
            CustomInput(
              controller: controller.descriptionController,
              label: "Deskripsi",
              hint: "Deskripsi menu (opsional)",
              maxLines: 3,
            ),

            const SizedBox(height: 15),

            // Kategori
            Obx(() {
              return CustomDropdown<int>(
                label: "Kategori",
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

            // Harga
            CustomInput(
              controller: controller.priceController,
              label: "Harga",
              hint: "Contoh: 15000",
              keyboardType: TextInputType.number,
              numberOnly: true,
            ),

            const SizedBox(height: 25),

            // Tombol simpan
            Obx(
              () => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : CustomButton(text: "Simpan", onTap: controller.addMenu),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}