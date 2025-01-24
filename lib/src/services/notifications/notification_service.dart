import 'package:app_tcareer/main.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';

class NotificationService {
  GlobalKey<NavigatorState> navigatorKey;

  NotificationService(this.navigatorKey);

  void initialize() async {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        playSound: true,
        channelShowBadge: true,
        criticalAlerts: true,
        importance: NotificationImportance.Max,
        channelGroupKey: 'notify_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
      )
    ], channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'notify_group',
        channelGroupName: 'push notify group',
      )
    ]);
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> displayNotification(RemoteMessage message) async {
    print(">>>>>>>>>>>data = ${message.data}");
    String fullName = message.data['full_name'].toString();
    String image = message.notification?.android?.imageUrl ??
        "https://ui-avatars.com/api/?name=$fullName&background=random";
    // String postId = message.data["id"];
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    if (message.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              payload: {
            "post_id": message.data["post_id"],
            "related_user_id": message.data['related_user_id'],
            "type": message.data['type'],
            "application_id": message.data['application_id'],
            "job_id": message.data['job_id']
          },
              // autoDismissible: true,
              displayOnForeground: true,
              displayOnBackground: true,
              roundedLargeIcon: false,
              wakeUpScreen: true,
              largeIcon: image,
              id: notificationId,
              // icon: '',
              badge: 0,
              criticalAlert: true,
              channelKey: 'basic_channel',
              duration: const Duration(seconds: 3),
              title: message.notification?.title,
              body: message.notification?.body,
              category: NotificationCategory.Social,
              notificationLayout: NotificationLayout.Messaging));
      await AwesomeNotifications().shouldShowRationaleToRequest();
      await AwesomeNotifications()
          .setListeners(onActionReceivedMethod: onActionReceivedMethod);
    }
  }

  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    await directToPage(receivedAction);
  }

  Future<void> directToPage(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    print(">>>>>>>>payload: $payload");
    final postId = payload["post_id"]?.toString();
    final userId = payload["related_user_id"]?.toString();
    final type = payload['type']?.toString();
    final applicationId = payload['application_id']?.toString();
    final context = navigatorKey.currentContext;
    final jobId = payload['job_id']?.toString();
    if (postId != null &&
        postId.isNotEmpty &&
        type?.contains("COMMENT") == true) {
      // Điều hướng đến chi tiết bài viết với type là COMMENT
      context?.pushNamed(
        "detail",
        pathParameters: {"id": postId},
        queryParameters: {"notificationType": type},
      );
    } else if (postId != null && postId.isNotEmpty) {
      context?.pushNamed(
        "detail",
        pathParameters: {"id": postId},
      );
    } else if (type?.contains("CHAT") == true &&
        userId != null &&
        userId.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String clientId = prefs.getString("userId").toString();
      context?.pushReplacementNamed("chat",
          pathParameters: {"userId": userId ?? "", "clientId": clientId});
    } else if (userId != null && userId.isNotEmpty) {
      print(">>>>>>>>>>>2");
      context?.pushNamed(
        'profile',
        queryParameters: {"userId": userId},
      );
    } else if (type?.contains("APPLICATION_SUBMITTED") == true &&
        applicationId != null &&
        applicationId.isNotEmpty) {
      print(">>>>>>>>>>>>>>123123");
      navigatorKey.currentContext?.pushNamed("applyJob",
          queryParameters: {"applicationId": applicationId});
    } else if (type?.contains("APPLICATION_VIEWED") == true) {
      context?.pushReplacementNamed("jobDetail",
          pathParameters: {"id": jobId.toString()}, extra: JobType.applied);
    }
  }
}

final notificationServiceProvider =
    Provider.family<NotificationService, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  return NotificationService(navigatorKey);
});
