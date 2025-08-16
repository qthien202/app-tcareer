import 'package:flutter/material.dart';
import 'package:notification/src/domain/entities/notification_entity.dart';
class NotificationItemWidget extends StatelessWidget {
  final NotificationEntity data;
  final VoidCallback onTap;
  const NotificationItemWidget({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = data.isRead != true
        ? Colors.blue.shade300.withOpacity(0.2)
        : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(data.avatar),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.content,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.updatedAt,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Divider(
                  //   height: 1,
                  //   color: Colors.grey.shade100,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


