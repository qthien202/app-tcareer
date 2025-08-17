import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/notification.dart';
import 'package:notification/src/data/models/notification_click_event.dart';
import 'package:notification/src/data/models/notification_received_event.dart';
import 'package:go_router/go_router.dart';
import 'package:notification/src/data/services/firebase_messaging_service.dart';
import 'package:notification/src/data/services/notification_service.dart';

class NotificationHandler {
  final NotificationService _service;
  final FirebaseMessagingService _fcmService;
  final UserUtils _userUtils;
  final GlobalKey<NavigatorState> _navigatorKey;
  NotificationHandler(
    this._service,
    this._userUtils,
    this._navigatorKey,
    this._fcmService,
  );

  void init() {
    _service.initialize();
    _fcmService.configureFirebaseMessaging();
    AppEventBus.on<NotificationReceivedEvent>().listen((event) {
      Log.json(event.data, name: "APP-NOTIFICATION");
      _service.showNotification(event.data);
    });
    AppEventBus.on<NotificationClickEvent>().listen(_handleClickNotification);
  }

  void _handleClickNotification(NotificationClickEvent event) async {
    final context = _navigatorKey.currentContext;
    final payload = event.payload;
    String? routeName;
    Map<String, String>? pathParameters;
    Map<String, String>? queryParameters;
    switch (payload.type) {
      case NotificationType.COMMENT_POST:
      case NotificationType.REPLY_COMMENT:
        routeName = "detail";
        pathParameters = {"id": payload.postId.toString()};
        queryParameters = {"notificationType": payload.type.name};
        break;

      case NotificationType.LIKE_POST:
      case NotificationType.SHARE_POST:
      case NotificationType.LIKE_COMMENT:
        routeName = "detail";
        pathParameters = {"id": payload.postId.toString()};
        break;

      case NotificationType.FOLLOW:
      case NotificationType.SENT_REQUEST_FRIEND:
      case NotificationType.ACCEPT_REQUEST_FRIEND:
        routeName = "profile";
        queryParameters = {"userId": payload.userId.toString()};
        break;
      case NotificationType.CHAT:
        routeName = "chat";
        String clientId = await _userUtils.getUserId();
        pathParameters = {"userId": payload.userId ?? "", "clientId": clientId};

      default:
        break;
    }

    if (routeName != null) {
      if (routeName == "chat") {
        context?.pushReplacementNamed("chat",
            pathParameters: pathParameters ?? {});
        return;
      }
      context?.pushNamed(
        routeName,
        pathParameters: pathParameters ?? {},
        queryParameters: queryParameters ?? {},
      );
    }
  }
}

final notificationHandlerProvider = Provider<NotificationHandler>((ref) {
  final service = ref.watch(notificationServiceProvider);
  final userUtils = ref.watch(userUtilsProvider);
  final navigatorKey = ref.watch(navigatorKeyProvider);
  final fcm = ref.watch(firebaseMessagingServiceProvider);
  final handler = NotificationHandler(service, userUtils, navigatorKey, fcm);
  return handler;
});
