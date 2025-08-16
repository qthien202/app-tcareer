import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notification/notification.dart' as noti;

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(noti.notificationNotifierProvider.notifier);
    return noti.NotificationPage(
      onTap: (data) async {
        await notifier.readNotification(data.id);
        _directToPage(context: context, notification: data);
      },
    );
  }

  void _directToPage({
    required BuildContext context,
    required noti.NotificationEntity notification,
  }) {
    switch (notification.type) {
      case noti.NotificationType.COMMENT_POST:
      case noti.NotificationType.REPLY_COMMENT:
        if (notification.postId != null) {
          context.pushNamed(
            "detail",
            pathParameters: {"id": notification.postId.toString()},
            queryParameters: {"notificationType": notification.type.name},
          );
        }
        break;
      case noti.NotificationType.LIKE_POST:
      case noti.NotificationType.SHARE_POST:
      case noti.NotificationType.LIKE_COMMENT:
        if (notification.postId != null) {
          context.pushNamed(
            "detail",
            pathParameters: {"id": notification.postId.toString()},
          );
        }
        break;

      case noti.NotificationType.FOLLOW:
      case noti.NotificationType.SENT_REQUEST_FRIEND:
      case noti.NotificationType.ACCEPT_REQUEST_FRIEND:
        if (notification.relatedUserId != null) {
          context.pushNamed(
            "profile",
            queryParameters: {"userId": notification.relatedUserId.toString()},
          );
        }
        break;

      default:
        break;
    }
  }
}
