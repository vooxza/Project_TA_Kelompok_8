import 'package:get/get.dart';
import 'dart:async';

class HomePageController extends GetxController {
  RxInt quantity = 1.obs;
  RxString selectedCategory = 'Makanan'.obs;
  RxInt currentPaketIndex = 0.obs;

  Timer? _autoSlideTimer;

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

  @override
  void onInit() {
    super.onInit();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      currentPaketIndex.value =
          (currentPaketIndex.value + 1) % paketList.length;
    });
  }

  void goToPaket(int index) {
    currentPaketIndex.value = index;
    _autoSlideTimer?.cancel();
    _startAutoSlide();
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  @override
  void onClose() {
    _autoSlideTimer?.cancel();
    super.onClose();
  }
}