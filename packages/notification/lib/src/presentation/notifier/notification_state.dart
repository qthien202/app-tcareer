import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notification/src/domain/entities/notification_entity.dart';
part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState(
      {@Default([]) List<NotificationEntity> notifications,
      @Default(false) bool isLoading,
      String? errorMessage,
      @Default(0) int unreadCount}) = _NotificationState;
}
