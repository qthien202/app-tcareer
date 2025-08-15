import 'package:core/core.dart';
import 'package:notification/src/domain/entities/notification_entity.dart';
import 'package:notification/src/domain/repositories/notification_repository.dart';

class ListenNotificationUseCase {
  final NotificationRepository _repository;
  ListenNotificationUseCase(
    this._repository,
  );
  Stream<List<NotificationEntity>> call(String userId) {
    return _repository.listen().map((event) {
      final rawData = event.snapshot.value;
      final List<Map<dynamic, dynamic>> items = [];
      if (rawData is Map) {
        for (final entry in rawData.entries) {
          final element = entry.value;
          if (element is Map && element['user_id']?.toString() == userId) {
            final map = Map<dynamic, dynamic>.from(element);
            map['notification_id'] = entry.key;
            items.add(map);
          }
        }
      } else if (rawData is List) {
        for (final element in rawData) {
          if (element is Map &&
              element['user_id']?.toString() == userId.toString()) {
            items.add(Map<dynamic, dynamic>.from(element));
          }
        }
      }
      final notifications = items.map((e) {
        return NotificationEntity.fromMap(e['notification_id'], e);
      }).toList();

      notifications.sort((a, b) {
        return a.updatedAt
            .compareToDateTime(b.updatedAt, fallback: DateTime(0));
      });
      return notifications;
    });
  }
}
