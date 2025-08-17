import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/data/models/app_notification.dart';
import 'package:notification/src/data/models/notification_click_event.dart';
import 'package:notification/src/data/models/notification_payload.dart';

class NotificationService {
  NotificationService();

  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'tcareer_channel',
          channelName: 'TCareer Notification',
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
          channelKey: "tcareer_channel",
          title: data.title,
          body: data.body,
          largeIcon: data.imageUrl,
          payload: data.payload.toMap(),
          displayOnForeground: true,
          displayOnBackground: true,
          notificationLayout: NotificationLayout.Messaging,
          groupKey: data.payload.userId),
    );
    await AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    Log.i("On click notification");
    final payload = receivedAction.payload;
    if (payload != null) {
      final safePayload =
          payload.map((key, value) => MapEntry(key, value ?? ""));
      AppEventBus.fire(
        NotificationClickEvent(
          payload: NotificationPayload.fromMap(safePayload),
        ),
      );
    }
  }
}

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());
