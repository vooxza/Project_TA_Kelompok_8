class Order {
  final int? id;
  final String orderNumber;
  final int userId;
  final double totalAmount;
  final String status;
  final String? notes;
  final List<OrderItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    required this.orderNumber,
    required this.userId,
    required this.totalAmount,
    required this.status,
    this.notes,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  // 🔥 helper biar gak error String -> num
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    return Order(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      userId: _toInt(json['user_id']),
      totalAmount: _toDouble(json['total_price']),
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      items: items,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      quantity: _toInt(json['quantity']),
      price: _toDouble(json['price']),
    );
  }
}