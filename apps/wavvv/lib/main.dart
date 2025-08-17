import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/domain/app_initializer.dart';
import 'package:app_tcareer/src/services/device_info_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_messaging_service.dart';
import 'package:app_tcareer/src/services/notifications/notification_handler.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:core/core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final container = ProviderContainer();
  container.read(deviceInfoProvider).configuration();
  final navigatorKey = container.read(navigatorKeyProvider);
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase đã được khởi tạo trước đó.');
    } else {
      rethrow;
    }
  }
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider(""),
  );
  await Future.delayed(const Duration(milliseconds: 100));

  await AppInitializer().init(container);
  // FirebaseMessaging.onBackgroundMessage(
  //   backgroundHandler,
  // );
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(
      // overrides: [navigatorKeyProvider.overrideWithValue(navigatorKey)],
      child: App(
    navigatorKey: navigatorKey,
  )));
}
