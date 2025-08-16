import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationIconWidget extends StatelessWidget {
  final int unreadCount;
  final bool? isActive;
  const NotificationIconWidget(
      {super.key, required this.unreadCount, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -8, end: -5),
      showBadge: unreadCount != 0,
      ignorePointer: false,
      badgeContent: Text(
        "$unreadCount",
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
      child: Visibility(
        visible: isActive != true,
        replacement: const PhosphorIcon(
          PhosphorIconsFill.bell,
        ),
        child: const PhosphorIcon(
          PhosphorIconsRegular.bell,
          size: 20,
        ),
      ),
    );
  }
}
