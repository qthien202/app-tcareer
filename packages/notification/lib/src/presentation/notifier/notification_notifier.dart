import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Future<NotificationState> build() async {
    _listenNotificationUseCase = ref.read(listenNotificationUseCaseProvider);
    _userUtils = ref.read(userUtilsProvider);
    _readNotificationUseCase = ref.read(readNotificationUseCaseProvider);

    state = const AsyncValue.data(NotificationState(isLoading: true));

    _subscription?.cancel();

    ref.onDispose(() {
      _subscription?.cancel();
    });

    await _listenNotification();

    return const NotificationState(isLoading: true);
  }

  Future<void> _listenNotification() async {
    try {
      final userId = await _userUtils.getUserId();

      if (userId.isEmpty) {
        state = const AsyncValue.data(NotificationState(
            notifications: [], isLoading: false, errorMessage: null));
        return;
      }

      _subscription = _listenNotificationUseCase(userId).listen(
        (notifications) {
          if (!ref.exists(notificationNotifierProvider)) return;

          state = AsyncValue.data(NotificationState(
              notifications: notifications,
              isLoading: false,
              errorMessage: null));
        },
        onError: (error, stackTrace) {
          if (!ref.exists(notificationNotifierProvider)) return;

          state = AsyncValue.data(NotificationState(
              notifications: state.value?.notifications ?? [],
              isLoading: false,
              errorMessage: error.toString()));
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> readNotification(String notificationId) async {
    await _readNotificationUseCase(notificationId);
  }

  Future<void> refresh() async {
    await _listenNotification();
  }
}

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, NotificationState>(() {
  return NotificationNotifier();
});
