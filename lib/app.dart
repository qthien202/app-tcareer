import 'package:app_tcareer/src/features/user/domain/connection_use_case.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'src/configs/app_colors.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_localization/flutter_localization.dart';

class App extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const App({
    required this.navigatorKey,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        Future.microtask(() async {
          final connectionUseCase = ref.watch(connectionUseCaseProvider);
          await connectionUseCase.monitorConnection();
        });
        final router = AppRouter.router(ref, widget.navigatorKey);

        return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            builder: (context, child) {
              ScreenUtil.init(context);
              final FlutterLocalization localization =
                  FlutterLocalization.instance;
              localization.init(
                mapLocales: [
                  const MapLocale('en', AppLocale.EN),
                  const MapLocale('km', AppLocale.KM),
                  const MapLocale('ja', AppLocale.JA),
                  const MapLocale('vi', AppLocale.VI), // Thêm tiếng Việt
                ],
                initLanguageCode: 'en',
              );
              return OverlaySupport.global(
                child: MaterialApp.router(
                  supportedLocales: localization.supportedLocales,
                  localizationsDelegates: localization.localizationsDelegates,
                  locale:
                      const Locale('vi', 'VN'), // Thiết lập locale cho ứng dụng
                  // localizationsDelegates: const [
                  //   GlobalMaterialLocalizations.delegate,
                  //   GlobalWidgetsLocalizations.delegate,
                  //   GlobalCupertinoLocalizations.delegate,
                  // ],
                  // supportedLocales: const [
                  //   Locale('en', 'US'), // English
                  //   Locale('vi', 'VN'), // Vietnamese
                  // ],
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                  title: 'TCareer',
                  theme: ThemeData(
                    progressIndicatorTheme:
                        ProgressIndicatorThemeData(color: AppColors.primary),
                    indicatorColor: AppColors.primary,
                    inputDecorationTheme: const InputDecorationTheme(
                        hintStyle:
                            TextStyle(color: Colors.black45, fontSize: 12)),
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                    appBarTheme: const AppBarTheme(
                        scrolledUnderElevation: 0.0,
                        backgroundColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.black),
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                        )),
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                      landscapeLayout:
                          BottomNavigationBarLandscapeLayout.centered,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedLabelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: AppColors.primary),
                  ),
                ),
              );
            }
            //   return MaterialApp(
            //     debugShowCheckedModeBanner: false,
            //     home: const UnsupportedPlatformPage(), // Trang thông báo
            //   );
            // },
            );
      },
    );
  }
}

mixin AppLocale {
  static const String title = 'title';

  static const Map<String, dynamic> EN = {title: 'Localization'};
  static const Map<String, dynamic> KM = {title: 'ការធ្វើមូលដ្ឋានីយកម្ម'};
  static const Map<String, dynamic> JA = {title: 'ローカリゼーション'};
  static const Map<String, dynamic> VI = {title: 'Đa ngôn ngữ'};
}

// final goRouterProvider = Provider<GoRouter>((ref) {
//   final navigatorKey = GlobalKey<NavigatorState>();
//   return AppRouter.router(ref, navigatorKey); // Truyền ref vào AppRouter
// });
