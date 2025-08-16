import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/notification.dart';
import 'package:notification/src/presentation/ui/widgets/notification_item_widget.dart';


class NotificationPage extends ConsumerWidget {
  final void Function(NotificationEntity data) onTap;
  const NotificationPage({
    super.key,
    required this.onTap,
  });

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
    return state.when(
        loading: () => circularLoadingWidget(),
        data: (data) {
          final notifications = data.notifications;
          return ListView.builder(
            itemCount: (notifications.length) > 20 ? 20 : notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationItemWidget(
                  data: notification,
                  onTap: () => onTap.call(notification));
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return emptyWidget("Không có thông báo nào");
        });
  }
}
