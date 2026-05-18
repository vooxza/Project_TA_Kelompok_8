import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'menu_controller.dart' as menu;
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart';
import 'package:project_ta_kelompok_8/core/services/api_service.dart';

class AddMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  var selectedImage = Rxn<String>();
  var selectedCategoryId = Rxn<int>();
  var categories = <Category>[].obs;
  var isLoading = false.obs;

  final menuController = Get.find<menu.MenuController>();
  final apiService = ApiService();
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final loadedCategories = await apiService.getCategories();
      categories.value = List<Category>.from(loadedCategories);
      if (categories.isNotEmpty) {
        selectedCategoryId.value = categories[0].id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage(String imagePath) {
    selectedImage.value = imagePath;
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

  Future<void> addMenu() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategoryId.value == null) {
      Get.snackbar('Error', 'Nama, harga, dan kategori wajib diisi');
      return;
    }

    try {
      isLoading.value = true;

      final price = double.tryParse(priceController.text) ?? 0.0;
      final description = descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim();

      if (selectedImage.value != null) {
        await apiService.createProductWithImage(
          nameController.text,
          price,
          0,
          selectedCategoryId.value!,
          File(selectedImage.value!),
          description: description,
        );
      } else {
        final newProduct = Product(
          name: nameController.text,
          description: description,
          price: price,
          stock: 0,
          image: null,
          categoryId: selectedCategoryId.value!,
        );
        await menuController.addMenuItem(newProduct);
      }

      await menuController.loadMenuItems();
      Get.back();
      Get.snackbar('Sukses', 'Menu berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal: $e');
    } finally {
      isLoading.value = false;
    }
  }
}