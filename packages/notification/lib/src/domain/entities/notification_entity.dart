import 'package:firebase_database/firebase_database.dart';
import 'package:notification/notification.dart';

class NotificationEntity {
  final String id;
  final String avatar;
  final String content;
  final String fullName;
  final bool isRead;
  final int? relatedUserId;
  final NotificationType type;
  final String updatedAt;
  final String userId;
  final String? postId;

  NotificationEntity({
    required this.id,
    required this.avatar,
    required this.content,
    required this.fullName,
    required this.isRead,
    this.relatedUserId,
    required this.type,
    required this.updatedAt,
    required this.userId,
    this.postId,
  });

  factory NotificationEntity.fromMap(String id, Map<dynamic, dynamic> map) {
    NotificationType parseType(String? typeStr) {
      if (typeStr == null) return NotificationType.OTHER;
      return NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == typeStr,
        orElse: () => NotificationType.OTHER,
      );
    }

    return NotificationEntity(
        id: id,
        avatar: map['avatar']?.toString() ?? '',
        content: map['content']?.toString() ?? '',
        fullName: map['full_name']?.toString() ?? '',
        isRead: map['is_read'] ?? false,
        relatedUserId: map['related_user_id'] != null
            ? int.tryParse(map['related_user_id'].toString()) ?? 0
            : 0,
        type: parseType(map['type']?.toString()),
        updatedAt: map['updated_at']?.toString() ?? '',
        userId: map['user_id']?.toString() ?? '',
        postId: map['post_id']?.toString() ?? '');
  }

  factory NotificationEntity.fromSnapshot(DataSnapshot snapshot) {
    return NotificationEntity.fromMap(
      snapshot.key ?? '',
      snapshot.value as Map<dynamic, dynamic>,
    );
  }
}
