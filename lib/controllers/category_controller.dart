import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart';
import 'package:project_ta_kelompok_8/services/api_service.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final apiService = ApiService();
  var _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    // Load data from API immediately on init
    ensureLoaded();
  }

  Future<void> ensureLoaded() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final loadedCategories = await apiService.getCategories();
      categories.value = List<Category>.from(loadedCategories);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error loading categories: $e');
      // Show error but don't show fallback mock data
      categories.value = [];
      Get.snackbar(
        'Error',
        'Failed to load categories from server',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createCategory(String name, {String? description}) async {
    try {
      isLoading.value = true;
      await apiService.createCategory(name, description: description);
      await loadCategories();
      Get.snackbar('Success', 'Category created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory(int id, String name, {String? description}) async {
    try {
      isLoading.value = true;
      await apiService.updateCategory(id, name, description: description);
      await loadCategories();
      Get.snackbar('Success', 'Category updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      isLoading.value = true;
      await apiService.deleteCategory(id);
      await loadCategories();
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
