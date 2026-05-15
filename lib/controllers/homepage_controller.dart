import 'package:get/get.dart';
import 'menu_controller.dart';

class HomePageController extends GetxController {
  RxInt quantity = 1.obs;
  RxString selectedCategory = 'Makanan'.obs;
  RxInt currentPaketIndex = 0.obs;

  final List<Map<String, dynamic>> paketList = [
    {
      'nama': 'Paket A',
      'deskripsi': 'Soto Ayam Spesial, Es Teh, Mendoan',
      'harga': 'Rp30.000',
      'image': 'assets/images/paket_a.png',
    },
    {
      'nama': 'Paket B',
      'deskripsi': 'Soto Daging, Jus Alpukat, Tempe Goreng',
      'harga': 'Rp35.000',
      'image': 'assets/images/paket_b.png',
    },
    {
      'nama': 'Paket C',
      'deskripsi': 'Soto Campur, Es Jeruk, Kerupuk',
      'harga': 'Rp25.000',
      'image': 'assets/images/paket_c.png',
    },
  ];

  void goToPaket(int index) {
    currentPaketIndex.value = index;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  // Saat kategori dipilih, sinkron juga ke MenuController
  void selectCategory(String category) {
    selectedCategory.value = category;

    // Sinkron ke MenuController supaya filter bekerja
    final menuController = Get.find<MenuController>();
    final matched = menuController.categories.firstWhereOrNull(
      (cat) => cat.name == category,
    );
    menuController.selectedCategoryId.value = matched?.id;
  }

  @override
  void onInit() {
    super.onInit();
    // Set kategori default ke yang pertama dari MenuController jika sudah load
    ever(Get.find<MenuController>().categories, (cats) {
      if (cats.isNotEmpty) {
        final matched = cats.firstWhereOrNull(
          (cat) => cat.name == selectedCategory.value,
        );
        Get.find<MenuController>().selectedCategoryId.value = matched?.id;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}