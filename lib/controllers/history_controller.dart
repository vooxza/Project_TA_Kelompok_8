import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project_ta_kelompok_8/core/services/api_service.dart';
import 'dart:convert';

class HistoryController extends GetxController {
  var isLoading = true.obs;
  var orderList = [].obs;
  var selectedTable = RxnString();
  var selectedDate = Rxn<DateTime>();
  var selectedMonthFilter = Rxn<DateTime>(); // filter per bulan
  var totalRevenue = 0.0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  bool get isAdmin => box.read('role') == 'admin';

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/order'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          orderList.value = data['data'];
          _calculateTotalRevenue();
        } else {
          orderList.value = [];
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Sesi Berakhir', 'Silahkan login kembali.');
      } else {
        Get.snackbar('Error', 'Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan jaringan');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refresh() async {
    selectedTable.value = null;
    selectedDate.value = null;
    selectedMonthFilter.value = null;
    await fetchOrders();
  }

  void _calculateTotalRevenue() {
    double total = 0;
    for (var order in orderList) {
      total += double.tryParse(order['total_price'].toString()) ?? 0.0;
    }
    totalRevenue.value = total;
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
}