import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/menu_controller.dart';
import '../widgets/dialog_button.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';

class EditMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController priceController;

  var selectedImage = Rxn<String>();
  final ImagePicker imagePicker = ImagePicker();

  final menuController = Get.find<MenuController>();

  int? menuId;

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    priceController = TextEditingController();

    final args = Get.arguments;

    if (args != null) {
      menuId = args['id'] as int?;
      nameController.text = args['name'] ?? '';
      priceController.text = args['price']?.toString() ?? '';
      selectedImage.value = args['image'];
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void changeImage(String imagePath) {
    selectedImage.value = imagePath;
  }

  Future<void> pickImageFromGallery() async {
    try {
      final status = Platform.isAndroid
    ? await Permission.storage.request()
    : await Permission.photos.request();

      if (status.isGranted) {
        final XFile? pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          selectedImage.value = pickedFile.path;
          Get.snackbar(
            'Success',
            'Image selected',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (status.isDenied) {
        Get.snackbar('Permission Denied', 'Gallery access required');
      } else if (status.isPermanentlyDenied) {
        Get.snackbar(
          'Permission Required',
          'Please enable gallery access in settings',
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to select image: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void saveMenu() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Name and Price cannot be empty');
      return;
    }

    final price = double.tryParse(priceController.text) ?? 0.0;

    try {
      if (menuId != null) {
        await menuController.apiService.updateProductWithImage(
          menuId!,
          nameController.text,
          price,
          0,
          1,
          selectedImage.value != null ? File(selectedImage.value!) : null,
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
            snackPosition: SnackPosition.BOTTOM,
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
