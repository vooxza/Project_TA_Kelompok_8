import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart' as cat;
import 'package:project_ta_kelompok_8/services/api_service.dart';

class MenuController extends GetxController {
  var menuItems = <Product>[].obs;
  var isLoading = false.obs;

  var categories = <cat.Category>[].obs;
  var selectedCategoryId = Rxn<int>();

  var errorMessage = ''.obs;
  final apiService = ApiService();
  var _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    ensureLoaded();
    loadCategories();
  }

  Future<void> ensureLoaded() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await loadMenuItems();
  }

  // 🔥 FILTER
  List<Product> get filteredMenu {
    if (selectedCategoryId.value == null) return menuItems;

    return menuItems
        .where((item) => item.categoryId == selectedCategoryId.value)
        .toList();
  }

  Future<void> loadCategories() async {
    try {
      final result = await apiService.getCategories();
      categories.value = result;

      if (categories.isNotEmpty) {
        selectedCategoryId.value = categories.first.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal load category');
    }
  }

  Future<void> loadMenuItems() async {
    try {
      isLoading.value = true;
      final products = await apiService.getProducts();
      menuItems.value = products;
    } catch (e) {
      debugPrint('Error: $e');
      menuItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMenuItems() async {
    await loadMenuItems();
  }

  Future<void> deleteMenuItem(int id) async {
    await apiService.deleteProduct(id);
    await loadMenuItems();
  }

  Future<void> addMenuItem(Product item) async {
    await apiService.createProduct(
      item.name,
      item.price,
      item.stock,
      item.categoryId,
    );
    await loadMenuItems();
  }

  Future<void> updateMenuItem(Product item) async {
    await apiService.updateProduct(
      item.id ?? 0,
      item.name,
      item.price,
      item.stock,
      item.categoryId,
    );
    await loadMenuItems();
  }
}