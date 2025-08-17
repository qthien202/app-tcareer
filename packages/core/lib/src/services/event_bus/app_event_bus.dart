import 'package:event_bus/event_bus.dart';

class AppEventBus {
  AppEventBus._internal();

  static final AppEventBus _instance = AppEventBus._internal();

  factory AppEventBus() => _instance;

  static final EventBus _eventBus = EventBus();

  static void fire(dynamic event) {
    _eventBus.fire(event);
  }

  static Stream<T> on<T>() {
    return _eventBus.on<T>();
  }
}
