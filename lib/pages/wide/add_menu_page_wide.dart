import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_menu_controller.dart';
import '../../widgets/common/wide_page_container.dart';
import '../../widgets/menu/add & edit/custom_button.dart';
import '../../widgets/menu/add & edit/custom_dropdown.dart';
import '../../widgets/menu/add & edit/custom_input.dart';
import '../../widgets/menu/add & edit/form_header_wide.dart';
import '../../widgets/menu/add & edit/image_picker_box.dart';

/// Versi widescreen dari AddMenuPage. Form & logic sama persis dengan versi
/// mobile — hanya reflow jadi dua kolom: gambar produk di kiri, field form
/// di kanan, supaya tidak perlu scroll panjang di layar lebar. Memakai
/// [WidePageContainer] supaya tampilannya satu kanvas cream penuh.
class AddMenuPageWide extends GetView<AddMenuController> {
  const AddMenuPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return WidePageContainer(
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormHeaderWide(title: 'Tambah Menu'),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kiri: gambar produk
                  Expanded(
                    child: Obx(
                      () => ImagePickerBox(
                        imagePath: controller.selectedImage.value,
                        onTap: controller.pickImageFromGallery,
                      ),
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
                        Obx(() {
                          return CustomDropdown<int>(
                            label: "Kategori",
                            value: controller.selectedCategoryId.value,
                            items: controller.categories.map((cat) {
                              return DropdownMenuItem(
                                  value: cat.id, child: Text(cat.name));
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
                          hint: "Contoh: 15000",
                          keyboardType: TextInputType.number,
                          numberOnly: true,
                        ),
                        const SizedBox(height: 25),
                        Obx(
                          () => controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : CustomButton(
                                  text: "Simpan",
                                  onTap: controller.addMenu,
                                ),
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
