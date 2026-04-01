import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;
  
  var selectedImage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    stockController = TextEditingController();
    descriptionController = TextEditingController();
    
    // Pre-fill with existing data if editing
    final args = Get.arguments;
    if (args != null) {
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
      Get.snackbar('Error', 'Nama dan Stok tidak boleh kosong');
      return;
    }
    
    Get.snackbar('Sukses', 'Menu berhasil disimpan');
    Get.back();
  }
}
