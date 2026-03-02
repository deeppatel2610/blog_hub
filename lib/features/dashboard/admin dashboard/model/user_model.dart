class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstname $lastname';

  String get avatarUrl =>
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}&background=FF6B35&color=fff&bold=true&size=128&rounded=true';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      role: json['role'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
      json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'role': role,
    'is_active': isActive,
  };

  UserModel copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? role,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}