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

  /// Map user_id -> nama user untuk menampilkan sumber transaksi
  var userMap = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  bool get isAdmin => box.read('role') == 'admin';

  /// Current user id — kasir hanya lihat miliknya sendiri
  int get currentUserId => box.read('user')?['id'] ?? 0;

  Future<void> _fetchUserNames() async {
    try {
      String? token = box.read('token');
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) return;
        final data = json.decode(response.body);
        final List users = data is List ? data : (data['data'] ?? []);
        final map = <int, String>{};
        for (final u in users) {
          final id = u['id'];
          final name = u['name'];
          if (id != null && name != null) {
            map[id] = name;
          }
        }
        userMap.value = map;
      }
    } catch (_) {
      // abaikan — jika gagal, nama user tidak akan tampil
    }
  }

  /// Dapatkan nama user berdasarkan user_id
  String getUserName(int? userId) {
    if (userId == null) return 'Admin';
    return userMap[userId] ?? 'Kasir #$userId';
  }

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
        if (response.body.isEmpty) {
          orderList.value = [];
          return;
        }
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

    // Ambil daftar user untuk mapping nama (berguna untuk admin)
    if (isAdmin) {
      await _fetchUserNames();
    }
  }

  @override
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
    String result = amount.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $result';
  }
}