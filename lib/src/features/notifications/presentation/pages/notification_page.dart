import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/features/notifications/presentation/widgets/notification_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        title: Text(
          "Thông báo",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: notifications(ref),
    );
  }

  Widget notifications(WidgetRef ref) {
    final controller = ref.watch(notificationControllerProvider);
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.notificationsStream(),
        builder: (context, snapshot) {
          // print(">>>>>>>>>>data1: ${snapshot.data}");
          if (!snapshot.hasData) {
            return circularLoadingWidget();
          }
          if (snapshot.data?.isEmpty == true) {
            return emptyWidget("Không có thông báo nào!");
          }
          final notifications = snapshot.data;
          return ListView.builder(
            // separatorBuilder: (context, index) => const SizedBox(
            //   height: 10,
            // ),
            itemCount: (notifications?.length ?? 0) > 20
                ? 20
                : notifications?.length ?? 0,
            itemBuilder: (context, index) {
              // print(">>>>>>>notification: $notifications");
              final notification = notifications?[index];

              return notificationItem(notification ?? {}, context, ref);
            },
          );
        });
  }
}
