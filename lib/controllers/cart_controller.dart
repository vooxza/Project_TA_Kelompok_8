import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/core/services/api_service.dart';
import 'package:project_ta_kelompok_8/controllers/history_controller.dart';

class CartItemModel {
  final Product product;
  RxInt quantity;

  CartItemModel({required this.product, required int quantity})
      : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;
  var selectedTable = RxnString();
  var isLoading = false.obs;
  final apiService = ApiService();

  int getItemQuantity(int productId) {
    final cartItem = cartItems.firstWhereOrNull(
      (item) => item.product.id == productId,
    );
    return cartItem?.quantity.value ?? 0;
  }

  void addToCart(Product item) {
    final index = cartItems.indexWhere((cart) => cart.product.id == item.id);
    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItemModel(product: item, quantity: 1));
    }
    cartItems.refresh();
  }

  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((cart) => cart.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity.value++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((cart) => cart.product.id == productId);
    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        cartItems.removeAt(index);
      }
      cartItems.refresh();
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((cart) => cart.product.id == productId);
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity.value);
    });
  }

  String formatRupiah(double amount) {
    final amountInt = amount.toInt();
    String result = amountInt.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $result';
  }

  Future<void> checkout(int userId) async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar('Error', 'Cart kosong');
        return;
      }

      if (selectedTable.value == null) {
        Get.snackbar('Error', 'Pilih meja dulu');
        return;
      }

      isLoading.value = true;

      final items = cartItems.map((item) {
        return {
          "product_id": item.product.id,
          "quantity": item.quantity.value,
          "price": item.product.price,
          "subtotal": item.product.price * item.quantity.value,
        };
      }).toList();

      await apiService.createOrder(
        totalPrice: totalPrice,
        items: items,
        tableNumber: selectedTable.value!,
      );

      clearCart();

      // ✅ Refresh history setelah checkout berhasil
      final historyController = Get.find<HistoryController>();
      await historyController.refresh();

      Get.snackbar('Sukses', 'Order berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', 'Gagal checkout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedTable.value = null;
  }
}