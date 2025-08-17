import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification/notification.dart';

class AppInitializer {
  Future<void> init(ProviderContainer ref) async {
    ref.read(notificationHandlerProvider).init();
  }
}
