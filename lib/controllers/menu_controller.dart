import 'package:get/get.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final int stock;
  final String price;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.stock,
    required this.price,
  });
}

class MenuController extends GetxController {
  var menuItems = <MenuItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenuItems();
  }

  void loadMenuItems() {
    isLoading.value = true;
    // Simulate loading menu items
    menuItems.value = [
      MenuItem(
        id: '1',
        name: 'Soto Ayam',
        description: '5 Varian',
        image: 'assets/images/soto_ayam.png',
        stock: 20,
        price: 'Rp 15.000',
      ),
      MenuItem(
        id: '2',
        name: 'Minuman',
        description: '5 Varian',
        image: 'assets/images/minuman.png',
        stock: 15,
        price: 'Rp 5.000',
      ),
      MenuItem(
        id: '3',
        name: 'Gorengan',
        description: '5 Varian',
        image: 'assets/images/gorengan.png',
        stock: 25,
        price: 'Rp 8.000',
      ),
      MenuItem(
        id: '4',
        name: 'Kerupuk',
        description: '5 Varian',
        image: 'assets/images/kerupuk.png',
        stock: 30,
        price: 'Rp 3.000',
      ),
    ];
    isLoading.value = false;
  }

  void deleteMenuItem(String id) {
    menuItems.removeWhere((item) => item.id == id);
  }

  void addMenuItem(MenuItem item) {
    menuItems.add(item);
  }

  void updateMenuItem(MenuItem item) {
    final index = menuItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      menuItems[index] = item;
    }
  }
}
