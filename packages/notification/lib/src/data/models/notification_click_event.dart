import 'package:notification/src/data/models/notification_payload.dart';

class NotificationClickEvent {
  final NotificationPayload payload;
  final bool isForeground;

  NotificationClickEvent({
    required this.payload,
    this.isForeground = true,
  });
}
