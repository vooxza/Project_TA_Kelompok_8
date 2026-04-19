import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'menu_controller.dart' as menu;
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart';
import 'package:project_ta_kelompok_8/services/api_service.dart';

class AddMenuController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController priceController;

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
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
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

  Future<void> requestGalleryPermission() async {
    final status = await Permission.photos.request();

    if (status.isDenied) {
      Get.snackbar('Permission Denied', 'App requires gallery access');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      Get.snackbar(
        'Permission Required',
        'Please enable gallery access in settings',
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final status = await Permission.photos.request();

      if (status.isGranted) {
        final XFile? pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          selectedImage.value = pickedFile.path;
          Get.snackbar('Success', 'Image selected',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else if (status.isDenied) {
        Get.snackbar('Permission Denied', 'App requires gallery access');
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


  Future<void> addMenu() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategoryId.value == null) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      isLoading.value = true;

      final price = double.tryParse(priceController.text) ?? 0.0;

      // Note: Send null for image since local file paths can't be sent directly to API
      // Image upload functionality should be implemented separately
      final newProduct = Product(
        name: nameController.text,
        description: null,
        price: price,
        stock: 0,
        image: null,
        categoryId: selectedCategoryId.value ?? 1,
      );

      debugPrint('Adding menu item: ${newProduct.name}');
      await menuController.addMenuItem(newProduct);
      debugPrint('Menu item added successfully');

      // Clear form
      nameController.clear();
      priceController.clear();
      selectedImage.value = null;

      Get.back();
      Get.snackbar(
        'Success',
        'Menu item added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB71C1C),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error adding menu: $e');
      Get.snackbar(
        'Error',
        'Failed to add menu: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
