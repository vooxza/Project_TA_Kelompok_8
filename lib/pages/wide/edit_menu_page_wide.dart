import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_menu_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/menu/add & edit/custom_button.dart';
import '../../widgets/menu/add & edit/custom_dropdown.dart';
import '../../widgets/menu/add & edit/custom_input.dart';
import '../../widgets/menu/add & edit/form_header_wide.dart';
import '../../widgets/menu/add & edit/image_picker_box.dart';

/// Versi widescreen dari EditMenuPage. Sama seperti AddMenuPage versi wide:
/// gambar + tombol ganti gambar di kiri, field form + tombol simpan/hapus
/// di kanan. Memakai [WidePageContainer] supaya tampilannya satu kanvas
/// cream penuh.
class EditMenuPageWide extends GetView<EditMenuController> {
  const EditMenuPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormHeaderWide(title: 'Edit Menu'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kiri: gambar produk
                  Expanded(
                    child: Column(
                      children: [
                        Obx(() => ImagePickerBox(
                              imagePath: controller.selectedImage.value,
                              onTap: controller.pickImageFromGallery,
                            )),
                        const SizedBox(height: 15),
                        CustomButton(
                          text: "Ganti Gambar",
                          onTap: controller.pickImageFromGallery,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Kanan: form
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Obx(() => CustomDropdown<int>(
                              label: "Category",
                              value: controller.selectedCategoryId.value,
                              items: controller.categories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat.id,
                                  child: Text(cat.name),
                                );
                              }).toList(),
                              onChanged: (value) => controller
                                  .selectedCategoryId.value = value,
                            )),
                        const SizedBox(height: 15),
                        CustomInput(
                          controller: controller.priceController,
                          label: "Harga",
                          hint: "Harga menu",
                          keyboardType: TextInputType.number,
                          numberOnly: true,
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: "Simpan",
                                onTap: controller.saveMenu,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: "Hapus Menu",
                                color: AppColors.error,
                                onTap: controller.deleteMenu,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
