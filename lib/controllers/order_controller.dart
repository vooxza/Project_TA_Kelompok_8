import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/models/order_model.dart';
import 'package:project_ta_kelompok_8/models/payment_model.dart';
import 'package:project_ta_kelompok_8/services/api_service.dart';

class OrderController extends GetxController {
  var orders = <Order>[].obs;
  var currentOrder = Rxn<Order>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final apiService = ApiService();
  var _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    // Don't load in onInit to avoid blocking UI
  }

  Future<void> ensureLoaded() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final loadedOrders = await apiService.getOrders();
      orders.value = loadedOrders;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading orders: $e');
      // Set empty list as fallback
      orders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderDetails(int orderId) async {
    try {
      isLoading.value = true;
      final order = await apiService.getOrderById(orderId);
      currentOrder.value = order;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch order details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Payment> createPayment(int orderId, double amount,
      {String paymentMethod = 'qris'}) async {
    try {
      isLoading.value = true;
      final payment = await apiService.createPayment(
        orderId,
        amount,
        paymentMethod: paymentMethod,
      );
      await loadOrders();
      Get.snackbar('Success', 'Payment created successfully');
      return payment;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create payment: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<PaymentStatus> checkPaymentStatus(int orderId) async {
    try {
      final status = await apiService.getPaymentStatus(orderId);
      return status;
    } catch (e) {
      Get.snackbar('Error', 'Failed to check payment status: $e');
      rethrow;
    }
  }
}
