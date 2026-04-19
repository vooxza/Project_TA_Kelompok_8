import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project_ta_kelompok_8/models/category_model.dart' as category_models;
import 'package:project_ta_kelompok_8/models/product_model.dart';
import 'package:project_ta_kelompok_8/models/order_model.dart';
import 'package:project_ta_kelompok_8/models/payment_model.dart';

class ApiService {
  static const String baseUrl =
      'https://nanometer-campfire-sediment.ngrok-free.dev/api';
  static const int timeout = 15; // Reduced from 30 to 15 seconds

  // Helper method to make GET requests
  Future<dynamic> _getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: timeout),
        onTimeout: () => throw Exception('Request timeout - API server not responding'),
      );

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

  // Helper method to make POST requests
  Future<dynamic> _postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      debugPrint('POST Request to: $baseUrl$endpoint');
      debugPrint('POST Payload: ${jsonEncode(data)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(
        Duration(seconds: timeout),
        onTimeout: () => throw Exception('Request timeout - API server not responding'),
      );

      debugPrint('POST Response Status: ${response.statusCode}');
      debugPrint('POST Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 302 || response.statusCode == 301) {
        throw Exception('API redirect detected (${response.statusCode}) - ngrok URL may have expired. Check ngrok tunnel status.');
      } else {
        throw Exception('Failed to post data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('POST Error: $e');
      throw Exception('Error: $e');
    }
  }

  // Helper method to make PUT requests
  Future<dynamic> _putRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(
        Duration(seconds: timeout),
        onTimeout: () => throw Exception('Request timeout - API server not responding'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 302 || response.statusCode == 301) {
        throw Exception('API redirect detected (${response.statusCode}) - ngrok URL may have expired. Check ngrok tunnel status.');
      } else {
        throw Exception('Failed to update data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Helper method to make DELETE requests
  Future<void> _deleteRequest(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: timeout),
        onTimeout: () => throw Exception('Request timeout - API server not responding'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ================== CATEGORIES ==================

  Future<List<category_models.Category>> getCategories() async {
    try {
      final response = await _getRequest('/categories');
      List<dynamic> data = response is List ? response : response['data'] ?? [];
      return data.map((item) => category_models.Category.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<category_models.Category> getCategoryById(int id) async {
    try {
      final response = await _getRequest('/categories/$id');
      return category_models.Category.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  Future<category_models.Category> createCategory(String name, {String? description}) async {
    try {
      final response = await _postRequest('/categories', {
        'name': name,
        'description': description,
      });
      return category_models.Category.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  Future<category_models.Category> updateCategory(int id, String name,
      {String? description}) async {
    try {
      final response = await _putRequest('/categories/$id', {
        'name': name,
        'description': description,
      });
      return category_models.Category.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _deleteRequest('/categories/$id');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // ================== PRODUCTS ==================

  Future<List<Product>> getProducts() async {
    try {
      final response = await _getRequest('/products');
      List<dynamic> data = response is List ? response : response['data'] ?? [];
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _getRequest('/products/$id');
      return Product.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  Future<Product> createProduct(
    String name,
    double price,
    int stock,
    int categoryId, {
    String? description,
    String? image,
  }) async {
    try {
      final response = await _postRequest('/products', {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'image': image,
        'category_id': categoryId,
      });
      return Product.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to create product: $e');
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
    try {
      final response = await _putRequest('/products/$id', {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'image': image,
        'category_id': categoryId,
      });
      return Product.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _deleteRequest('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // ================== ORDERS ==================

  Future<List<Order>> getOrders() async {
    try {
      final response = await _getRequest('/orders');
      List<dynamic> data = response is List ? response : response['data'] ?? [];
      return data.map((item) => Order.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<Order> getOrderById(int id) async {
    try {
      final response = await _getRequest('/orders/$id');
      return Order.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  Future<Order> createOrder(
    int userId,
    double totalAmount,
    List<Map<String, dynamic>> items, {
    String? notes,
  }) async {
    try {
      final response = await _postRequest('/orders', {
        'userId': userId,
        'totalAmount': totalAmount,
        'notes': notes,
        'items': items,
      });
      return Order.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // ================== PAYMENTS ==================

  Future<Payment> createPayment(
    int orderId,
    double amount, {
    String paymentMethod = 'qris',
  }) async {
    try {
      final response = await _postRequest('/payments', {
        'orderId': orderId,
        'amount': amount,
        'paymentMethod': paymentMethod,
      });
      return Payment.fromJson(response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  Future<PaymentStatus> getPaymentStatus(int orderId) async {
    try {
      final response = await _getRequest('/payment/status/$orderId');
      return PaymentStatus.fromJson(
          response is Map ? response : response['data']);
    } catch (e) {
      throw Exception('Failed to fetch payment status: $e');
    }
  }
}
