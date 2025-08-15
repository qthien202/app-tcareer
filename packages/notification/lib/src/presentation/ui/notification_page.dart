import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/presentation/notifier/notification_notifier.dart';

import 'notification_item.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Divider(
            color: Colors.grey.shade200,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Thông báo",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: notifications(ref),
    );
  }

  Widget notifications(WidgetRef ref) {
    final state = ref.watch(notificationNotifierProvider);
    final notifier = ref.watch(notificationNotifierProvider.notifier);
    return state.when(
        loading: () => circularLoadingWidget(),
        data: (data) {
          final notifications = data.notifications;
          return ListView.builder(
            itemCount: (notifications.length ?? 0) > 20
                ? 20
                : notifications.length ?? 0,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return notificationItem(
                  data: notification,
                  context: context,
                  onTap: () => notifier.directToPage(
                      context: context, notification: notification));
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return emptyWidget("Không có thông báo nào");
        });
  }
}
