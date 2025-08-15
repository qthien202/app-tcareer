import 'package:notification/src/domain/repositories/notification_repository.dart';

class ReadNotificationUseCase {
  final NotificationRepository _repository;
  ReadNotificationUseCase(this._repository);
  Future<void> call(String notificationId) async =>
      await _repository.read(notificationId);
}
