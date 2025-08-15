import 'package:firebase_database/firebase_database.dart';

abstract class NotificationRepository {
  Stream<DatabaseEvent> listen();

  Future<void> read(String notificationId);

  Future<String> addNotification(Map<String, dynamic> data);

  Future<void> markAllRead();

  Future<void> delete(String notificationId);
}
