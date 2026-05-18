import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart'
    as cat;
import 'package:project_ta_kelompok_8/core/services/api_service.dart';

class MenuController extends GetxController {
  final apiService = ApiService();
  var menuItems = <Product>[].obs;

  var categories = <cat.Category>[].obs;
  var selectedCategoryId = Rxn<int>();

  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    await loadMenuItems();
    await loadCategories();
  }

  List<Product> get filteredMenu {
    debugPrint('=== filteredMenu called ===');

    return menuItems.where((item) {
      /// FILTER CATEGORY
      final matchCategory =
          selectedCategoryId.value == null ||
          item.categoryId == selectedCategoryId.value;

      /// FILTER SEARCH
      final matchSearch = item.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  Future<void> loadCategories() async {
    try {
      final result = await apiService.getCategories();
      categories.value = result;

      if (categories.isNotEmpty) {
        selectedCategoryId.value = categories.first.id;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal load category',
      );
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
      description: item.description,
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
      description: item.description,
    );
    await loadMenuItems();
  }
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}