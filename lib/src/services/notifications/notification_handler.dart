import 'package:app_tcareer/src/services/firebase/firebase_messaging_service.dart';
import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationHandler {
  final FirebaseMessagingService firebaseMessagingService;
  final NotificationService notificationService;
  final GlobalKey<NavigatorState> navigatorKey;
  NotificationHandler(this.firebaseMessagingService, this.notificationService,
      this.navigatorKey);

  void initializeNotificationServices() {
    notificationService.initialize();
    firebaseMessagingService.configureFirebaseMessaging();
    firebaseMessagingService.handleForegroundMessage();
  }
}

final notificationProvider =
    Provider.family<NotificationHandler, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final firebaseMessagingService =
      ref.watch(firebaseMessagingServiceProvider(navigatorKey));
  final notificationService =
      ref.watch(notificationServiceProvider(navigatorKey));
  return NotificationHandler(
      firebaseMessagingService, notificationService, navigatorKey);
});
