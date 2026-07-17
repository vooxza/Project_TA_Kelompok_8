import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_menu_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/menu/add & edit/custom_button.dart';
import '../../widgets/menu/add & edit/custom_dropdown.dart';
import '../../widgets/menu/add & edit/custom_input.dart';
import '../../widgets/menu/add & edit/image_picker_box.dart';

/// Versi widescreen dari AddMenuPage. Form & logic sama persis dengan versi
/// mobile — hanya reflow jadi dua kolom: gambar produk di kiri, field form
/// di kanan, supaya tidak perlu scroll panjang di layar lebar.
class AddMenuPageWide extends GetView<AddMenuController> {
  const AddMenuPageWide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 18),
                  color: AppColors.primaryRed,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.textWhite),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Tambah Menu',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
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
          ),
        ),
      ),
    );
  }
}
