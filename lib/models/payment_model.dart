class Payment {
  final int? id;
  final int orderId;
  final double amount;
  final String status; // 'pending', 'completed', 'failed'
  final String paymentMethod; // 'qris', 'transfer', etc
  final String? qrisCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.qrisCode,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int?,
      orderId: json['orderId'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['paymentMethod'] as String? ?? 'qris',
      qrisCode: json['qrisCode'] as String?,
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
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'qrisCode': qrisCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class PaymentStatus {
  final int orderId;
  final String status; // 'pending', 'completed', 'failed'
  final DateTime? updatedAt;

  PaymentStatus({
    required this.orderId,
    required this.status,
    this.updatedAt,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      orderId: json['orderId'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
