import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/services/device_info_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_messaging_service.dart';
import 'package:app_tcareer/src/services/notifications/notification_handler.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

// final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
//   return GlobalKey<NavigatorState>();
// });
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.transparent, // Màu nền của thanh điều hướng
    systemNavigationBarIconBrightness: Brightness.light, // Màu biểu tượng
    systemNavigationBarDividerColor:
        Colors.transparent, // Màu đường phân cách (nếu có)
  ));
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final container = ProviderContainer();
  container.read(deviceInfoProvider).configuration();
  try {
    await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyBa2suLLiuvDmkTisxPg1oxxYojKx40zhw",
              authDomain: "tcareer-4fa7d.firebaseapp.com",
              projectId: "tcareer-4fa7d",
              storageBucket: "tcareer-4fa7d.appspot.com",
              messagingSenderId: "353946571533",
              appId: "1:353946571533:web:f540d00c325bb1d272d644",
              measurementId: "G-JRVZ98QJCR")
          : DefaultFirebaseOptions.currentPlatform,
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
  await Future.delayed(Duration(milliseconds: 100));
  container
      .read(notificationProvider(navigatorKey))
      .initializeNotificationServices();
  FirebaseMessaging.onBackgroundMessage(
    backgroundHandler,
  );
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(
      // overrides: [navigatorKeyProvider.overrideWithValue(navigatorKey)],
      child: App(
    navigatorKey: navigatorKey,
  )));
}
