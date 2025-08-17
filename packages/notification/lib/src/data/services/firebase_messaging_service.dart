import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/data/models/app_notification.dart';
import 'package:notification/src/data/models/notification_received_event.dart';
import 'package:core/core.dart';

void handleIncomingNotification(RemoteMessage message) {
  AppEventBus.fire(
    NotificationReceivedEvent(
      data: AppNotification.fromRemoteMessage(message),
    ),
  );
}

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  handleIncomingNotification(message);
}

class FirebaseMessagingService {
  final UserUtils userUtils;
  final Ref ref;
  FirebaseMessagingService(this.userUtils, this.ref);
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  void configureFirebaseMessaging() async {
    final deviceToken = await fcm.getToken();
    Log.i(deviceToken ?? "", name: "DEVICE-TOKEN");
    await userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");

    fcm.getInitialMessage().then((message) {
      if (message != null) handleIncomingNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleIncomingNotification);
    FirebaseMessaging.onMessage.listen(handleIncomingNotification);
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    await fcm.requestPermission(alert: true, badge: true, sound: true);
    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

final firebaseMessagingServiceProvider = Provider((ref) {
  final userUtils = ref.read(userUtilsProvider);
  return FirebaseMessagingService(userUtils, ref);
});
