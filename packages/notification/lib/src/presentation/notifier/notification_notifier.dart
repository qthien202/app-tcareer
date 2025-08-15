import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notification/src/domain/entities/notification_entity.dart';

import 'package:notification/src/domain/usecases/listen_notification_usecase.dart';
import 'package:notification/src/domain/usecases/read_notification_usecase.dart';

import '../../domain/notification_provider.dart';
import 'notification_state.dart';

class NotificationNotifier extends AsyncNotifier<NotificationState> {
  late final ListenNotificationUseCase _listenNotificationUseCase;
  late final UserUtils _userUtils;
  late final ReadNotificationUseCase _readNotificationUseCase;
  StreamSubscription<List<NotificationEntity>>? _subscription;
  NotificationNotifier();

  @override
  Future<NotificationState> build() async {
    _listenNotificationUseCase = ref.read(listenNotificationUseCaseProvider);
    _userUtils = ref.read(userUtilsProvider);
    _readNotificationUseCase = ref.read(readNotificationUseCaseProvider);
    await _listenNotification();
    return state.value ?? const NotificationState();
  }

  Future<void> _listenNotification() async {
    state = const AsyncValue.loading();
    final userId = await _userUtils.getUserId();
    if (userId.isEmpty) {
      state = const AsyncValue.data(NotificationState());
      return;
    }
    _subscription = _listenNotificationUseCase(userId).listen((notifications) {
      state = AsyncValue.data(NotificationState(
          notifications: notifications, isLoading: false, errorMessage: null));
    }, onError: (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  Future<void> readNotification(String notificationId) async {
    await _readNotificationUseCase(notificationId);
  }

  Future<void> directToPage(
      {required BuildContext context,
      required NotificationEntity notification}) async {
    readNotification(notification.id);
    final isNotificationPost = notification.postId != null;
    final isNotificationProfile = notification.relatedUserId != null;
    final isNotificationComment =
        notification.type == NotificationType.COMMENT &&
            notification.postId != null;
    if (isNotificationPost) {
      context.pushNamed("detail",
          pathParameters: {"id": notification.postId.toString()});
    }
    if (isNotificationProfile) {
      context.pushNamed('profile',
          queryParameters: {"userId": notification.relatedUserId.toString()});
    }
    if (isNotificationComment) {
      context.pushNamed("detail",
          pathParameters: {"id": notification.postId.toString()},
          queryParameters: {"notificationType": notification.type.name});
    }
  }
}

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, NotificationState>(() {
  return NotificationNotifier();
});
