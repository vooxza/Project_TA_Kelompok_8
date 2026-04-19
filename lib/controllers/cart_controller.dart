import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/services/api_service.dart';

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

  /// Add to cart
  void addToCart(Product item) {
    final index = cartItems.indexWhere((cart) => cart.product.id == item.id);

    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItemModel(product: item, quantity: 1));
    }

    cartItems.refresh();
  }

  /// Increase quantity
  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((cart) => cart.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity.value++;
      cartItems.refresh();
    }
  }

  /// Decrease quantity
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

  /// Remove item directly
  void removeFromCart(int productId) {
    cartItems.removeWhere((cart) => cart.product.id == productId);
  }

  /// Total price
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity.value);
    });
  }

  /// Format rupiah
  String formatRupiah(double amount) {
    final amountInt = amount.toInt();
    String result = amountInt.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $result';
  }

  /// Create order from cart
  Future<void> checkout(int userId) async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar('Error', 'Cart is empty');
        return;
      }

      isLoading.value = true;

      final items = cartItems
          .map((item) => {
                'productId': item.product.id,
                'quantity': item.quantity.value,
                'price': item.product.price,
              })
          .toList();

      final order = await apiService.createOrder(
        userId,
        totalPrice,
        items,
      );

      clearCart();
      Get.snackbar('Success', 'Order created successfully: ${order.orderNumber}');
      Get.offNamed('/order-confirmation', arguments: order);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedTable.value = null;
  }
}
