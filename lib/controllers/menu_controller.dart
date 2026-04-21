import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/services/api_service.dart';

class MenuController extends GetxController {
  var menuItems = <Product>[].obs;
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
    await loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    try {
      isLoading.value = true; 
      errorMessage.value = '';
      final products = await apiService.getProducts();
      menuItems.value = products;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error loading menu items: $e');
      // Show error but don't show fallback mock data
      menuItems.value = [];
      Get.snackbar(
        'Error',
        'Failed to load menu items from server',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMenuItems() async {
    try {
      isLoading.value = true;
      final products = await apiService.getProducts();
      menuItems.value = products;
      errorMessage.value = '';
      Get.snackbar(
        'Success',
        'Menu refreshed',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error refreshing menu items: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh menu',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }


  Future<void> deleteMenuItem(int id) async {
    try {
      isLoading.value = true;
      await apiService.deleteProduct(id);
      menuItems.removeWhere((item) => item.id == id);
      Get.snackbar('Success', 'Menu item deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMenuItem(Product item) async {
    try {
      isLoading.value = true;
      await apiService.createProduct(
        item.name,
        item.price,
        item.stock,
        item.categoryId,
        description: item.description,
        image: item.image,
      );
      await loadMenuItems(); // Refresh the list
      Get.snackbar('Success', 'Menu item added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMenuItem(Product item) async {
    try {
      isLoading.value = true;
      await apiService.updateProduct(
        item.id ?? 0,
        item.name,
        item.price,
        item.stock,
        item.categoryId,
        description: item.description,
        image: item.image,
      );
      await loadMenuItems(); // Refresh the list
      Get.snackbar('Success', 'Menu item updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
