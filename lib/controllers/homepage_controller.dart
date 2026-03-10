import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxInt quantity = 1.obs;
  RxString selectedCategory = 'Makanan'.obs;

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize any data here
  }

  @override
  void onClose() {
    super.onClose();
  }
}
