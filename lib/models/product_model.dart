class Product {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? image;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.image,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case keys from API
    final price = json['price'];
    double parsedPrice = 0.0;
    
    if (price is String) {
      parsedPrice = double.tryParse(price) ?? 0.0;
    } else if (price is num) {
      parsedPrice = price.toDouble();
    }
    
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: parsedPrice,
      stock: json['stock'] as int? ?? 0,
      image: json['image'] as String?,
      categoryId: (json['categoryId'] ?? json['category_id'] ?? 0) as int,
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'categoryId': categoryId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
