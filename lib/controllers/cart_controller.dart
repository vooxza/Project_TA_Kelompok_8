import 'package:get/get.dart';
import 'menu_controller.dart';

class CartItemModel {
  final MenuItem menuItem;
  RxInt quantity;

  CartItemModel({required this.menuItem, required int quantity})
    : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;
  var selectedTable = RxnString();

  /// Tambah ke keranjang
  void addToCart(MenuItem item) {
    final index = cartItems.indexWhere((cart) => cart.menuItem.id == item.id);

    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      cartItems.add(CartItemModel(menuItem: item, quantity: 1));
    }

    cartItems.refresh();
  }

  /// Tambah quantity
  void incrementQuantity(String itemId) {
    final index = cartItems.indexWhere((cart) => cart.menuItem.id == itemId);
    if (index != -1) {
      cartItems[index].quantity.value++;
      cartItems.refresh();
    }
  }

  /// Kurang quantity
  void decrementQuantity(String itemId) {
    final index = cartItems.indexWhere((cart) => cart.menuItem.id == itemId);

    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        cartItems.removeAt(index);
      }
      cartItems.refresh();
    }
  }

  /// Hapus item langsung
  void removeFromCart(String itemId) {
    cartItems.removeWhere((cart) => cart.menuItem.id == itemId);
  }

  /// Convert "Rp 15.000" -> 15000
  int parsePrice(String price) {
    return int.parse(
      price.replaceAll('Rp', '').replaceAll('.', '').replaceAll(' ', ''),
    );
  }

  /// Total harga
  int get totalPrice {
    return cartItems.fold(0, (sum, item) {
      return sum + (parsePrice(item.menuItem.price) * item.quantity.value);
    });
  }

  /// Format rupiah
  String formatRupiah(int amount) {
    String result = amount.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $result';
  }

  void clearCart() {
    cartItems.clear();
    selectedTable.value = null;
  }
}
