import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  
  var selectedImage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void selectImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  void addMenu() {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty || selectedImage.value == null) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }
    
    Get.snackbar('Sukses', 'Menu berhasil ditambahkan');
    Get.back();
  }
}
