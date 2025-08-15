import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/src/data/repositories/notification_repository_impl.dart';
import 'package:notification/src/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final database = ref.watch(realtimeDatabaseServiceProvider);
  return NotificationRepositoryImpl(database);
});
