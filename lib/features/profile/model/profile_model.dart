class ProfileModel {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProfileModel({
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

  String get initials =>
      '${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}';

  String get avatarUrl =>
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullName)}&background=FF6B35&color=fff&bold=true&size=160&rounded=true';

  String get formattedCreatedAt => _formatDate(createdAt);
  String get formattedUpdatedAt =>
      updatedAt != null ? _formatDate(updatedAt!) : 'Never';

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      role: json['role'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}