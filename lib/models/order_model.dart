class Order {
  final int? id;
  final String orderNumber;
  final int userId;
  final double totalAmount;
  final String status; // 'pending', 'completed', 'cancelled'
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

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Order(
      id: json['id'] as int?,
      orderNumber: json['orderNumber'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      items: items,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
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

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      orderId: json['orderId'] as int? ?? 0,
      productId: json['productId'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
