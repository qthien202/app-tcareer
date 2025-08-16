import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/data/models/app_notification.dart';

class NotificationService {
  NotificationService();

  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
    );

    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> showNotification(
    AppNotification data,
  ) async {
    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: data.payload.userId ?? "",
        title: data.title,
        body: data.body,
        largeIcon: data.imageUrl,
        payload: data.payload.toMap(),
        displayOnForeground: true,
        displayOnBackground: true,
        notificationLayout: NotificationLayout.Messaging,
      ),
    );
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());
