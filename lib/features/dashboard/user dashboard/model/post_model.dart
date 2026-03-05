class PostModel {
  final int id;
  final String title;
  final String content;
  final int userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  String get shortContent {
    if (content.length <= 120) return content;
    return '${content.substring(0, 120)}...';
  }

  String get readTime {
    final words = content.split(' ').length;
    final minutes = (words / 200).ceil();
    return '${minutes < 1 ? 1 : minutes} min read';
  }

  String get authorAvatarUrl =>
      'https://ui-avatars.com/api/?name=User+$userId&background=FF6B35&color=fff&bold=true&size=64&rounded=true';

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  bool get isUpdated => updatedAt != null;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['user_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
      json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'user_id': userId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}