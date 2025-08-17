import 'package:notification/notification.dart';

class NotificationPayload {
  final String? postId;
  final String? userId;
  final NotificationType type;
  final String? applicationId;
  final String? conversationId;
  final String? jobId;

  NotificationPayload({
    this.postId,
    this.userId,
    required this.type,
    this.applicationId,
    this.conversationId,
    this.jobId,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    NotificationType parseType(String? typeStr) {
      if (typeStr == null) return NotificationType.OTHER;
      return NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == typeStr,
        orElse: () => NotificationType.OTHER,
      );
    }

    return NotificationPayload(
      postId: data['post_id']?.toString(),
      userId: data['related_user_id']?.toString(),
      type: parseType(data['type']?.toString()),
      applicationId: data['application_id']?.toString(),
      conversationId: data['conversation_id']?.toString(),
      jobId: data['job_id']?.toString(),
    );
  }

  Map<String, String> toMap() {
    return {
      if (postId != null) 'post_id': postId!,
      if (userId != null) 'related_user_id': userId!,
      'type': type.name,
      if (applicationId != null) 'application_id': applicationId!,
      if (conversationId != null) 'conversation_id': conversationId!,
      if (jobId != null) 'job_id': jobId!,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'related_user_id': userId,
      'type': type.name,
      'application_id': applicationId,
      'conversation_id': conversationId,
      'job_id': jobId,
    };
  }
}
