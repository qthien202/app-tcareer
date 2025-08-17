import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_payload.dart';

class AppNotification {
  final String? title;
  final String? body;
  final String? imageUrl;
  final NotificationPayload payload;

  AppNotification({
    this.title,
    this.body,
    this.imageUrl,
    required this.payload,
  });

  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;

    return AppNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      payload: NotificationPayload.fromMap(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'payload': payload.toJson(),
    };
  }
}
