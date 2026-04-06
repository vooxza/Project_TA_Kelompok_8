import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart' as my_menu;
import '../widgets/dialog_button.dart';

class EditMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;

  var selectedImage = Rxn<String>();

  final my_menu.MenuController menuController =
      Get.find<my_menu.MenuController>();

  String? menuId;

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    stockController = TextEditingController();
    descriptionController = TextEditingController();

    final args = Get.arguments;

    if (args != null) {
      menuId = args['id'];
      nameController.text = args['name'] ?? '';
      stockController.text = args['stock']?.toString() ?? '';
      descriptionController.text = args['description'] ?? '';
      selectedImage.value = args['image'];
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void changeImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  void saveMenu() {
    if (nameController.text.isEmpty || stockController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama dan Stok tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB71C1C),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    final updatedItem = my_menu.MenuItem(
      id: menuId ?? DateTime.now().toString(),
      name: nameController.text,
      description: descriptionController.text,
      image: selectedImage.value ?? '',
      stock: int.tryParse(stockController.text) ?? 0,
      price: 'Rp 0',
    );

    if (menuId != null) {
      menuController.updateMenuItem(updatedItem);
    } else {
      menuController.addMenuItem(updatedItem);
    }

    Get.snackbar(
      'Sukses',
      'Menu berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB71C1C),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );

    Get.back();
  }

  void deleteMenu() {
    if (menuId == null) return;

    Get.dialog(
      CustomDialog(
        title: "Konfirmasi",
        message: "Yakin ingin menghapus menu ini?",
        textCancel: "Batal",
        textConfirm: "Hapus",
        buttonColor: const Color(0xFFB71C1C),
        onConfirm: () {
          menuController.deleteMenuItem(menuId!);

          Get.back(); // kembali ke halaman menu

          Get.snackbar(
            'Sukses',
            'Menu berhasil dihapus',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFB71C1C),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        },
      ),
    );
  }
}
