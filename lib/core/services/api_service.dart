import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart'
    as category_models;
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/order_model.dart';
import 'package:project_ta_kelompok_8/models/payment_model.dart';

class ApiService {
  static const String baseUrl =
      'http://103.247.8.11/api';
  static const int timeout = 15;

  final box = GetStorage();

  // ================== HEADER ==================
  Map<String, String> _headers({bool useAuth = true}) {
    final token = box.read('token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (useAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ================== GET ==================
  Future<dynamic> _getRequest(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: _headers())
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ================== POST ==================
  Future<dynamic> _postRequest(
    String endpoint,
    Map<String, dynamic> data, {
    bool useAuth = true,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers(useAuth: useAuth),
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to post data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ================== PUT ==================
  Future<dynamic> _putRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers(),
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to update data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ================== DELETE ==================
  Future<void> _deleteRequest(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: _headers())
          .timeout(Duration(seconds: timeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ================== AUTH ==================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _postRequest(
        '/login',
        {'email': email, 'password': password},
        useAuth: false, // 🔥 penting
      );

      return response;
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  // ================== CATEGORIES ==================
  Future<List<category_models.Category>> getCategories() async {
    final response = await _getRequest('/categories');
    List<dynamic> data = response is List ? response : response['data'] ?? [];
    return data.map((item) => category_models.Category.fromJson(item)).toList();
  }

  Future<category_models.Category> getCategoryById(int id) async {
    final response = await _getRequest('/categories/$id');
    return category_models.Category.fromJson(
      response is Map ? response : response['data'],
    );
  }

  Future<category_models.Category> createCategory(
    String name, {
    String? description,
  }) async {
    final response = await _postRequest('/categories', {
      'name': name,
      'description': description,
    });

    return category_models.Category.fromJson(
      response is Map ? response : response['data'],
    );
  }

  Future<category_models.Category> updateCategory(
    int id,
    String name, {
    String? description,
  }) async {
    final response = await _putRequest('/categories/$id', {
      'name': name,
      'description': description,
    });

    return category_models.Category.fromJson(
      response is Map ? response : response['data'],
    );
  }

  Future<void> deleteCategory(int id) async {
    await _deleteRequest('/categories/$id');
  }

  // ================== PRODUCTS ==================
  Future<List<Product>> getProducts() async {
    final response = await _getRequest('/products');
    List<dynamic> data = response is List ? response : response['data'] ?? [];
    return data.map((item) => Product.fromJson(item)).toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _getRequest('/products/$id');
    return Product.fromJson(response is Map ? response : response['data']);
  }

  Future<Product> createProduct(
    String name,
    double price,
    int stock,
    int categoryId, {
    String? description,
    String? image,
  }) async {
    final response = await _postRequest('/products', {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'category_id': categoryId,
    });

    return Product.fromJson(response is Map ? response : response['data']);
  }

  Future<Product> createProductWithImage(
    String name,
    double price,
    int stock,
    int categoryId,
    File imageFile, {
    String? description,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products'),
      );

      final token = box.read('token');

      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['name'] = name;
      request.fields['price'] = price.toInt().toString();
      request.fields['stock'] = stock.toString();
      request.fields['category_id'] = categoryId.toString();

      if (description != null) {
        request.fields['description'] = description;
      }

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      var res = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Upload gagal: ${res.body}');
      }
    } catch (e) {
      throw Exception('Error upload: $e');
    }
  }

  Future<Product> updateProduct(
    int id,
    String name,
    double price,
    int stock,
    int categoryId, {
    String? description,
    String? image,
  }) async {
    final response = await _putRequest('/products/$id', {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'category_id': categoryId,
    });

    return Product.fromJson(response is Map ? response : response['data']);
  }

  Future<Product> updateProductWithImage(
    int id,
    String name,
    String? description,
    double price,
    int stock,
    int categoryId,
    File? imageFile,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/$id'),
      );

      final token = box.read('token');

      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['_method'] = 'PUT';
      request.fields['name'] = name;
      request.fields['description'] = description ?? '';
      request.fields['price'] = price.toInt().toString();
      request.fields['stock'] = stock.toString();
      request.fields['category_id'] = categoryId.toString();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      var response = await request.send();
      var res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Update gagal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error update: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    await _deleteRequest('/products/$id');
  }

  // ================== ORDERS ==================
  Future<List<Order>> getOrders() async {
    // _getRequest secara otomatis mengirimkan token dari user yang login
    // Laravel akan memfilter datanya berdasarkan role (Admin: semua, Kasir: hari ini)
    final response = await _getRequest('/order');

    // Pastikan mengambil data dari key 'data' sesuai response JSON Laravel kamu
    List<dynamic> data = response['data'] ?? [];
    return data.map((item) => Order.fromJson(item)).toList();
  }

  Future<Order> getOrderById(int id) async {
    final response = await _getRequest('/order/$id');
    return Order.fromJson(response['data'] ?? response);
  }

  Future<Order> createOrder({
    required double totalPrice,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    // AMBIL TOKEN DARI STORAGE
    String? token = box.read('token');

    final response = await http.post(
      Uri.parse('$baseUrl/order'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Sekarang $token sudah ada isinya
      },
      body: jsonEncode({
        'total_price': totalPrice,
        'items': items,
        'table_number': tableNumber,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to post data: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    final data = decoded is Map ? (decoded['data'] ?? decoded) : decoded;
    return Order.fromJson(data);
  }

  // ================== QRIS PAYMENT GATEWAY ==================
  // Kontrak sudah diverifikasi langsung ke backend (bukan tebakan):
  //   POST /api/payment/qris   body: { "order_number": "ORDER-XXXX" }
  //   GET  /api/payment/status/{order_number}
  // Kedua-duanya butuh header Authorization: Bearer <token> (sudah otomatis
  // dikirim oleh _postRequest/_getRequest).

  /// Minta pembayaran QRIS untuk sebuah order yang SUDAH dibuat. [orderNumber]
  /// wajib diisi (bukan id numerik, tapi kode order seperti "ORDER-0005").
  ///
  /// PENTING: kontrak backend saat ini balikin `snap_token` (dari Midtrans
  /// Snap API), BUKAN gambar QRIS langsung. Jadi return value method ini
  /// adalah URL HALAMAN PEMBAYARAN Midtrans (Snap redirection page) yang
  /// harus dibuka di browser/webview — bukan URL gambar buat <Image.network>.
  /// Kalau suatu saat backend diganti ke Core API QRIS charge (yang balikin
  /// qris_url/qr_url beneran), method ini otomatis makai itu duluan.
  Future<String> generateQris(String orderNumber) async {
    final response = await _postRequest('/payment/qris', {
      'order_number': orderNumber,
    });

    // Backend membalas { success: false, message: "..." } untuk kasus
    // error (mis. order sudah lunas) — lempar pesannya apa adanya supaya
    // gampang ditampilkan ke user.
    if (response is Map && response['success'] == false) {
      throw Exception(response['message'] ?? 'Gagal membuat QRIS');
    }

    final data = response is Map ? (response['data'] ?? response) : response;

    // Kasus ideal (kalau backend nanti pakai Core API QRIS charge):
    // ada gambar QR beneran, langsung dipakai.
    final directUrl = data is Map
        ? (data['qris_url'] ?? data['qr_url'] ?? data['url'])
        : null;
    if (directUrl != null && directUrl.toString().isNotEmpty) {
      return directUrl.toString();
    }

    // Kasus SEKARANG: backend balikin Snap token → susun URL halaman
    // pembayaran Midtrans-nya.
    final snapToken = data is Map ? data['snap_token'] : null;
    if (snapToken != null && snapToken.toString().isNotEmpty) {
      // TODO: pas go-live, ganti ke 'https://app.midtrans.com/snap/v4/redirection/'
      // (tanpa "sandbox") sesuai environment Midtrans yang dipakai backend.
      return 'https://app.sandbox.midtrans.com/snap/v4/redirection/$snapToken';
    }

    throw Exception(
      'Response QRIS tidak berisi qris_url maupun snap_token: $response',
    );
  }

  /// Cek status pembayaran untuk sebuah order (dipoll sampai "paid").
  Future<String> getQrisPaymentStatus(String orderNumber) async {
    final response = await _getRequest('/payment/status/$orderNumber');
    final data = response is Map ? (response['data'] ?? response) : response;
    final status = data is Map ? data['status'] : null;
    return (status ?? 'pending').toString();
  }

  // ================== PAYMENTS ==================
  Future<Payment> createPayment(
    int orderId,
    double amount, {
    String paymentMethod = 'qris',
  }) async {
    final response = await _postRequest('/payments', {
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
    });

    return Payment.fromJson(response is Map ? response : response['data']);
  }

  Future<PaymentStatus> getPaymentStatus(int orderId) async {
    final response = await _getRequest('/payment/status/$orderId');
    return PaymentStatus.fromJson(
      response is Map ? response : response['data'],
    );
  }
}