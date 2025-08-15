enum NotificationType {
  comment,
  chat,
  other,
}

class NotificationPayload {
  final String? postId;
  final String? userId;
  final NotificationType type;
  final String? applicationId;
  final String? conversationId;
  final String? jobId;
  final Map<String, dynamic> rawData;

  NotificationPayload({
    this.postId,
    this.userId,
    required this.type,
    this.applicationId,
    this.conversationId,
    this.jobId,
    required this.rawData,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    NotificationType parseType(String? typeStr) {
      if (typeStr == null) return NotificationType.other;
      final upper = typeStr.toUpperCase();
      if (upper.contains("COMMENT")) return NotificationType.comment;
      if (upper.contains("CHAT")) return NotificationType.chat;
      return NotificationType.other;
    }

    return NotificationPayload(
      postId: data['post_id']?.toString(),
      userId: data['related_user_id']?.toString(),
      type: parseType(data['type']?.toString()),
      applicationId: data['application_id']?.toString(),
      conversationId: data['conversation_id']?.toString(),
      jobId: data['job_id']?.toString(),
      rawData: data,
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
}
