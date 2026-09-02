import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/core/theme/app_colors.dart';
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

  // ================== QRIS PAYMENT GATEWAY ==================
  // order_number dari order yang berhasil dibuat lewat [checkout] — ini
  // yang dipakai untuk minta QRIS & cek status pembayaran (BUKAN id
  // numerik, tapi kode order seperti "ORDER-0005").
  String? lastOrderNumber;

  // CATATAN: qrisUrl ini isinya URL HALAMAN PEMBAYARAN Midtrans (Snap
  // redirection page), BUKAN URL gambar. Jangan dipasang ke Image.network,
  // harus dibuka pakai url_launcher (lihat QrisImageBox).
  var qrisUrl = RxnString();
  var qrisLoading = false.obs;
  var qrisError = RxnString();
  var isVerifyingPayment = false.obs;

  /// true kalau backend sudah konfirmasi order ini "selesai"/lunas
  /// (dicek otomatis lewat polling di [_startStatusPolling]). Tombol
  /// "Konfirmasi Pembayaran" di UI harus nonaktif selama ini masih false.
  var isQrisPaid = false.obs;
  Timer? _qrisPollTimer;

  /// Alur lengkap QRIS: pastikan order sudah dibuat (kalau belum, buat
  /// dulu lewat [checkout]), lalu minta URL pembayaran ke payment gateway,
  /// dan mulai polling status otomatis.
  /// Aman dipanggil berkali-kali (mis. dari initState widget) — kalau URL
  /// sudah ada atau sedang dimuat, tidak akan mengulang request.
  Future<void> startQrisPayment() async {
    if (qrisUrl.value != null || qrisLoading.value) return;

    qrisLoading.value = true;
    qrisError.value = null;
    isQrisPaid.value = false;
    try {
      if (lastOrderNumber == null) {
        final created = await checkout(1);
        if (!created) {
          qrisError.value = 'Gagal membuat order';
          return;
        }
      }
      qrisUrl.value = await apiService.generateQris(lastOrderNumber!);
      _startStatusPolling();
    } catch (e) {
      qrisError.value = 'Gagal memuat QRIS: $e';
    } finally {
      qrisLoading.value = false;
    }
  }

  /// Cek status pembayaran tiap beberapa detik selagi customer scan &
  /// bayar. Begitu backend bilang sudah lunas, [isQrisPaid] otomatis
  /// jadi true dan tombol "Konfirmasi Pembayaran" di UI aktif dengan
  /// sendirinya — TANPA ini, cashier bisa nekan tombol itu kapan aja
  /// walau belum benar-benar bayar.
  void _startStatusPolling() {
    _qrisPollTimer?.cancel();
    _qrisPollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (isQrisPaid.value) {
        _qrisPollTimer?.cancel();
        return;
      }
      final paid = await verifyQrisPaid();
      if (paid) {
        isQrisPaid.value = true;
        _qrisPollTimer?.cancel();
      }
    });
  }

  void _stopStatusPolling() {
    _qrisPollTimer?.cancel();
    _qrisPollTimer = null;
  }

  /// Cek ke payment gateway apakah order ini sudah berstatus "paid".
  /// Dipanggil oleh polling di atas, dan juga dipanggil lagi saat tombol
  /// "Konfirmasi Pembayaran" ditekan (double-check terakhir sebelum
  /// nampilin dialog sukses & cetak nota).
  ///
  /// CATATAN: backend balikin status "selesai" untuk pembayaran yang
  /// sudah lunas (bukan "paid"). Diterima juga beberapa alias umum
  /// (paid/success/settlement) jaga-jaga kalau backend berubah nanti.
  Future<bool> verifyQrisPaid() async {
    if (lastOrderNumber == null) return false;
    try {
      final status = await apiService.getQrisPaymentStatus(lastOrderNumber!);
      const paidStatuses = {'selesai', 'paid', 'success', 'settlement'};
      final paid = paidStatuses.contains(status.toLowerCase());
      if (paid) isQrisPaid.value = true;
      return paid;
    } catch (e) {
      return false;
    }
  }

  /// Reset state pembayaran QRIS (order_number, url, error, status polling).
  /// WAJIB dipanggil saat user keluar dari halaman Pembayaran TANPA
  /// berhasil bayar (mis. tombol back) — supaya kalau dia checkout lagi
  /// nanti, sistem bikin order + minta Snap URL yang BARU, bukan kepake
  /// yang lama/kadaluarsa terus, dan polling lama nggak nyangkut.
  void resetQrisPayment() {
    _stopStatusPolling();
    lastOrderNumber = null;
    qrisUrl.value = null;
    qrisError.value = null;
    qrisLoading.value = false;
    isQrisPaid.value = false;
  }

  @override
  void onClose() {
    _stopStatusPolling();
    super.onClose();
  }

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
    final isWhole = amount % 1 == 0;
    final raw = isWhole
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2).replaceAll('.', ',');
    final parts = raw.split(',');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final intPart = parts[0].replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $intPart${parts.length > 1 ? ',${parts[1]}' : ''}';
  }

  // Ubah return type jadi Future<bool> agar PaymentPage tahu sukses/gagal
  Future<bool> checkout(int userId) async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar('Perhatian', 'Cart masih kosong',
        backgroundColor: AppColors.snackbarWarning,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
        return false;
      }

      if (selectedTable.value == null) {
        Get.snackbar('Perhatian', 'Isi nama terlebih dahulu',
        backgroundColor: AppColors.snackbarWarning,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
        return false;
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

      final order = await apiService.createOrder(
        totalPrice: totalPrice,
        items: items,
        tableNumber: selectedTable.value!.trim(), // ← trim whitespace
      );
      lastOrderNumber = order.orderNumber;

      // ✅ JANGAN clearCart di sini, biarkan dialog yang handle
      final historyController = Get.find<HistoryController>();
      await historyController.refresh();

      return true; // ← kembalikan true jika sukses
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('401') || msg.toLowerCase().contains('unauthenticated')) {
        Get.snackbar('Sesi Berakhir', 'Login kamu sudah tidak valid, silakan login ulang.',
          backgroundColor: AppColors.snackbarError,
          colorText: AppColors.textWhite,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
        );
        Get.offAllNamed('/login');
        return false;
      }
      Get.snackbar('Gagal', 'Gagal checkout: $e',
        backgroundColor: AppColors.snackbarError,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );
      return false; // ← kembalikan false jika gagal
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() {
    _stopStatusPolling();
    cartItems.clear();
    selectedTable.value = null;
    lastOrderNumber = null;
    qrisUrl.value = null;
    qrisError.value = null;
    isQrisPaid.value = false;
  }
}