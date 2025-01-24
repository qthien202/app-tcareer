import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/main.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/services/notifications/notification_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  final NotificationService notificationService;
  final UserUtils userUtils;
  final Ref ref;
  final GlobalKey<NavigatorState> navigatorKey;
  FirebaseMessagingService(
      this.notificationService, this.userUtils, this.ref, this.navigatorKey);
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  void configureFirebaseMessaging() async {
    String? deviceToken = await fcm.getToken();
    await userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");
    print(">>>>>>>>>>deviceToken: $deviceToken");
    // fcm.subscribeToTopic("tcareer");
    fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        directToPage(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      directToPage(message);
    });

    // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kIsWeb) {
        String fullName = message.data['full_name'];
        String image = message.notification?.android?.imageUrl ??
            "https://ui-avatars.com/api/?name=$fullName&background=random";
        showSimpleNotification(
          background: Colors.white,
          duration: Duration(seconds: 5),
          ListTile(
            onTap: () async => await directToPage(message),
            leading: Image.network(
              image,
              fit: BoxFit.cover,
            ),
            title: Text(
              message.notification?.title ?? "",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              message.notification?.body ?? "",
              style: TextStyle(color: Colors.black45),
            ),
          ),
        );
      } else {
        notificationService.displayNotification(message);
      }
    });
  }

  Future<void> directToPage(RemoteMessage message) async {
    final context = navigatorKey.currentContext;
    final data = message.data;
    print(">>>>>>>>>data: $data");
    final postId = data["post_id"]?.toString();
    final userId = data['related_user_id']?.toString();
    final type = data['type']?.toString();
    final applicationId = data['application_id']?.toString();
    final conversationId = data['conversation_id']?.toString();
    final jobId = data['job_id']?.toString();

    if (context != null) {
      if (postId != null &&
          postId.isNotEmpty &&
          type?.contains("COMMENT") == true) {
        context.pushNamed(
          "detail",
          pathParameters: {"id": postId},
          queryParameters: {"notificationType": type},
        );
      } else if (postId != null && postId.isNotEmpty) {
        context.pushNamed(
          "detail",
          pathParameters: {"id": postId},
        );
      } else if (type?.contains("CHAT") == true &&
          userId != null &&
          userId.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String clientId = prefs.getString("userId").toString();
        context.pushReplacementNamed("chat",
            pathParameters: {"userId": userId ?? "", "clientId": clientId});
      } else if (userId != null && userId.isNotEmpty) {
        context.pushNamed(
          'profile',
          queryParameters: {"userId": userId},
        );
      } else if (type?.contains("APPLICATION_SUBMITTED") == true) {
        context.pushNamed("applyJob",
            queryParameters: {"applicationId": applicationId});
      } else if (type?.contains("APPLICATION_VIEWED") == true) {
        context.pushReplacementNamed("jobDetail",
            pathParameters: {"id": jobId.toString()}, extra: JobType.applied);
      }
    }
  }
}

final firebaseMessagingServiceProvider =
    Provider.family<FirebaseMessagingService, GlobalKey<NavigatorState>>(
        (ref, navigatorKey) {
  final notificationService =
      ref.watch(notificationServiceProvider(navigatorKey));
  final userUtils = ref.watch(userUtilsProvider);
  return FirebaseMessagingService(
      notificationService, userUtils, ref, navigatorKey);
});

Future<void> backgroundHandler(RemoteMessage message) async {
  final context = navigatorKey.currentContext;
  final data = message.data;
  print(">>>>>>>>>data: $data");
  final postId = data["post_id"]?.toString();
  final userId = data['related_user_id']?.toString();
  final type = data['type']?.toString();
  final applicationId = data['application_id']?.toString();
  final jobId = data['job_id']?.toString();

  if (context != null) {
    if (postId != null &&
        postId.isNotEmpty &&
        type?.contains("COMMENT") == true) {
      context.pushNamed(
        "detail",
        pathParameters: {"id": postId},
        queryParameters: {"notificationType": type},
      );
    } else if (postId != null && postId.isNotEmpty) {
      context.pushNamed(
        "detail",
        pathParameters: {"id": postId},
      );
    } else if (type?.contains("CHAT") == true &&
        userId != null &&
        userId.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String clientId = prefs.getString("userId").toString();
      context.pushReplacementNamed("chat",
          pathParameters: {"userId": userId ?? "", "clientId": clientId});
    } else if (userId != null && userId.isNotEmpty) {
      context.pushNamed(
        'profile',
        queryParameters: {"userId": userId},
      );
    } else if (type?.contains("APPLICATION_SUBMITTED") == true) {
      context.pushNamed("applyJob",
          queryParameters: {"applicationId": applicationId});
    } else if (type?.contains("APPLICATION_VIEWED") == true) {
      context.pushReplacementNamed("jobDetail",
          pathParameters: {"id": jobId.toString()}, extra: JobType.applied);
    }
  }
}
