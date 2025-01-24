import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationRepository {
  final Ref ref;

  NotificationRepository(this.ref);

  Stream<DatabaseEvent> listenToNotifications() {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "notification";
    final data = database.listenToData(path);

    return data;
  }

  Future<void> readNotification(String notificationId) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.updateValue(
        "notification/$notificationId", "is_read", true);
  }
}

final notificationRepositoryProvider =
    Provider((ref) => NotificationRepository(ref));
