import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controllers/menu_controller.dart';
import '../widgets/dialog_button.dart';
import '../models/category_model.dart';

class EditMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  var selectedImage = Rxn<String>();
  final ImagePicker imagePicker = ImagePicker();

  var selectedCategoryId = Rxn<int>();
  var categories = <Category>[].obs;

  final menuController = Get.find<MenuController>();

  int? menuId;

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    final args = Get.arguments;

    if (args != null) {
      menuId = args['id'] as int?;
      nameController.text = args['name'] ?? '';
      descriptionController.text = args['description'] ?? '';
      selectedCategoryId.value = args['category_id'];
      priceController.text = args['price']?.toString() ?? '';
      selectedImage.value = args['image'];
    }
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void changeImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  Future<void> loadCategories() async {
    final result = await menuController.apiService.getCategories();
    categories.value = result;
    final exists = categories.any((cat) => cat.id == selectedCategoryId.value);

    if (!exists && categories.isNotEmpty) {
      selectedCategoryId.value = categories.first.id;
    }
    update();
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImage.value = pickedFile.path;

        Get.snackbar(
          'Success',
          'Image selected',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void saveMenu() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Name and Price cannot be empty');
      return;
    }

    final price = double.tryParse(priceController.text) ?? 0.0;

    File? imageFile;

    if (selectedImage.value != null &&
        !selectedImage.value!.startsWith('http')) {
      imageFile = File(selectedImage.value!);
    }

    try {
      if (menuId != null) {
        await menuController.apiService.updateProductWithImage(
          menuId!,
          nameController.text,
          descriptionController.text,
          price,
          0,
          selectedCategoryId.value!,
          imageFile,
        );
      }

      await menuController.loadMenuItems();

      Get.back();
      Get.snackbar('Success', 'Menu berhasil diupdate');
    } catch (e) {
      Get.snackbar('Error', 'Gagal update: $e');
    }
  }

  void deleteMenu() {
    if (menuId == null) return;

    Get.dialog(
      CustomDialog(
        title: "Hapus Menu?",
        message: "Anda yakin ingin menghapus menu ini?",
        textCancel: "Batal",
        textConfirm: "Hapus",
        buttonColor: const Color(0xFFB71C1C),
        onConfirm: () {
          menuController.deleteMenuItem(menuId!);
          Get.back();
          Get.snackbar(
            'Success',
            'Menu berhasil dihapus',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFB71C1C),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        },
        onCancel: () => Get.back(),
      ),
    );
  }
}
