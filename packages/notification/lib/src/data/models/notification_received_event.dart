import 'app_notification.dart';

class NotificationReceivedEvent {
  final AppNotification data;
  final bool isForeground;

  NotificationReceivedEvent({
    required this.data,
    this.isForeground = true,
  });
}
