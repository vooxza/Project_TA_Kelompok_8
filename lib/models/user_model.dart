class UserModel {
  final int? id;
  final String name;
  final String email;
  final String role;
  final String status; // Diubah ke String agar selalu konsisten ('active' / 'inactive')
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Normalisasi parsing status dari berbagai kemungkinan format backend (bool, int, String, is_active)
    String parseStatus(dynamic rawStatus, dynamic rawIsActive) {
      final val = rawStatus ?? rawIsActive;
      
      if (val == null) return 'active';
      if (val is bool) return val ? 'active' : 'inactive';
      if (val is int) return val == 1 ? 'active' : 'inactive';
      
      final str = val.toString().toLowerCase().trim();
      if (str == 'inactive' || str == '0' || str == 'false' || str == 'nonaktif') {
        return 'inactive';
      }
      return 'active';
    }

    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'cashier',
      status: parseStatus(json['status'], json['is_active']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
    };
  }
}