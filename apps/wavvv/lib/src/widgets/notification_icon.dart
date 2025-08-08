import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget notificationIcon(WidgetRef ref, {bool active = false}) {
  final notificationController = ref.watch(notificationControllerProvider);
  return StreamBuilder<List<Map<String, dynamic>>>(
      stream: notificationController.unReadNotificationsStream(),
      builder: (context, snapshot) {
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: -8, end: -5),
          showBadge: snapshot.data?.isNotEmpty == true ? true : false,
          ignorePointer: false,
          badgeContent: Text(
            snapshot.data?.length.toString() ?? "",
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
          child: Visibility(
            visible: active != true,
            replacement: PhosphorIcon(
              PhosphorIconsFill.bell,
            ),
            child: PhosphorIcon(
              PhosphorIconsRegular.bell,
              size: 20,
            ),
          ),
        );
      });
}
