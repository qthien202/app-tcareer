import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/data/repositories/notification_repository_impl.dart';
import 'package:notification/src/domain/repositories/notification_repository.dart';
import 'package:notification/src/domain/usecases/listen_notification_usecase.dart';
import 'package:notification/src/domain/usecases/read_notification_usecase.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final database = ref.watch(realtimeDatabaseServiceProvider);
  return NotificationRepositoryImpl(database);
});

final listenNotificationUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return ListenNotificationUseCase(repository);
});

final readNotificationUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return ReadNotificationUseCase(repository);
});
