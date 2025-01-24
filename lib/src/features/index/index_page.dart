import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/job_topic_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/usercases/connection_use_case.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ably_flutter/ably_flutter.dart' as ably;

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      final userUtils = ref.watch(userUtilsProvider);
      String? topics = await userUtils.loadCache("topics");
      final jobTopicController = ref.watch(jobTopicControllerProvider);
      if (topics == null) {
        await jobTopicController.getTopicFavorite(context);
        if (jobTopicController.topicFavorites != null &&
            jobTopicController.topicFavorites?.data?.isEmpty == true) {
          context.goNamed("topics");
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appLifecycleNotifier = ref.read(appLifecycleProvider.notifier);
      final routeState = GoRouterState.of(context);
      await appLifecycleNotifier.updateState(state, ref, routeState);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': PhosphorIconsThin.house,
        'activeIcon': PhosphorIconsFill.house,
        'route': 'home',
        "label": "Trang chủ"
      },
      {
        'icon': PhosphorIconsThin.bagSimple,
        'activeIcon': PhosphorIconsFill.bagSimple,
        'route': 'jobs',
        "label": "Việc làm"
      },
      {
        'icon': PhosphorIconsThin.plusCircle,
        'activeIcon': PhosphorIconsFill.plusCircle,
        'route': 'posting',
        "label": "Tạo mới"
      },
      {
        'icon': PhosphorIconsThin.chatCenteredDots,
        'activeIcon': PhosphorIconsFill.chatCenteredDots,
        'route': 'conversation',
        "label": "Tin nhắn"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': 'user',
        "label": "Tài khoản"
      },
    ];
    final state = ref.watch(indexControllerProvider);
    final routerState = GoRouterState.of(context);
    bool isRouteValid =
        routerState.fullPath?.startsWith("/conversation/chat") == false &&
            routerState.fullPath?.startsWith("/user/resume") == false &&
            routerState.fullPath?.contains("/user/edit") == false &&
            routerState.fullPath?.startsWith('/jobs/') == false &&
            routerState.fullPath?.startsWith('/user/setting/changePassword') ==
                false;
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: Visibility(
        visible: state == true && isRouteValid,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              // selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(fontSize: 0),
              selectedLabelStyle: const TextStyle(fontSize: 0),
              onTap: (index) {
                if (index == 5) return;
                if (index != 2) {
                  if (index == widget.shell.currentIndex) {
                    final GoRouter router = GoRouter.of(context);
                    String currentRoute =
                        router.routeInformationProvider.value.uri.toString();
                    String route = items[index]['route'];
                    print(">>>>>>>>>>>>>>>>A");
                    context.goNamed(route, extra: "reload");
                  } else {
                    widget.shell.goBranch(index);
                  }
                } else {
                  // context.pushNamed("posting");
                  ref
                      .read(indexControllerProvider.notifier)
                      .showCreateBottomSheet(context);
                }
              },
              currentIndex: widget.shell.currentIndex,
              items: items.asMap().entries.map((entry) {
                final item = entry.value;
                final index = entry.key;
                return BottomNavigationBarItem(
                    icon: Visibility(
                      visible: index != 3,
                      replacement: chatIcon(ref),
                      child: PhosphorIcon(
                        item['icon'],
                        size: index != 2 ? 25 : 30,
                      ),
                    ),
                    activeIcon: Visibility(
                      visible: index != 3,
                      replacement: chatIcon(ref, active: true),
                      child: PhosphorIcon(
                        item['activeIcon'],
                        size: index != 2 ? 25 : 30,
                      ),
                    ),
                    label: item['label']);
              }).toList()),
        ),
      ),
    );
  }

  Widget chatIcon(WidgetRef ref, {bool active = false}) {
    final controller = ref.watch(conversationControllerProvider);
    return FutureBuilder<int>(
        future: controller.calculateUnReadMessage(context),
        builder: (context, snapshot) {
          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: -6, end: -5),
            showBadge: snapshot.hasData && snapshot.data != 0 ? true : false,
            ignorePointer: false,
            badgeContent: Text(
              snapshot.data.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.redAccent),
            child: Visibility(
              visible: active != true,
              replacement: const PhosphorIcon(
                PhosphorIconsFill.chatCenteredDots,
              ),
              child: const PhosphorIcon(
                PhosphorIconsThin.chatCenteredDots,
              ),
            ),
          );
        });
  }
}

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState> {
  AppLifecycleNotifier() : super(AppLifecycleState.resumed);

  Future<void> updateState(
      AppLifecycleState state, WidgetRef ref, GoRouterState routeState) async {
    this.state = state; // Cập nhật trạng thái
    final connectionUseCase = ref.read(connectionUseCaseProvider);
    final userUtil = ref.watch(userUtilsProvider);
    bool isAuthenticated = await userUtil.isAuthenticated();
    final chatController = ref.read(chatControllerProvider);
    if (!isAuthenticated) return;
    print(">>>>>>>>>>state: $state");
    if (state == AppLifecycleState.paused) {
      // if (isAuthenticated) {
      await connectionUseCase.setUserOfflineStatus();
      // await chatController.messageSubscription.cancel();
      // }
    } else if (state == AppLifecycleState.resumed) {
      // print(">>>>>>>>app is forceground");
      bool isChatRoute =
          routeState.fullPath?.contains("conversation") == true ||
              routeState.fullPath?.startsWith("/conversation/chat") == true ||
              routeState.fullPath?.contains("jobs/conversations") == true ||
              routeState.fullPath?.startsWith("/jobs/chat") == true;
      print(">>>>>>>>>>fullPath: ${routeState.fullPath}");
      if (isChatRoute) {
        await connectionUseCase.setUserOnlineStatusInMessage();
        // await ref.read(conversationControllerProvider).listenAblyConnected(
        //     handleChannelStateChange: (connectionState) async {
        //       print(">>>>>>>state: ${connectionState.event}");
        //       if (connectionState.event == ably.ConnectionEvent.closed) {
        //         await ref.read(conversationControllerProvider).initializeAbly();
        //       }
        //       if (connectionState.event == ably.ConnectionEvent.connected) {
        //         await ref
        //             .read(conversationControllerProvider)
        //             .listenAllConversation();
        //       }
        //     });
        // await con

        print(">>>>>>>>>>1");
      } else {
        await connectionUseCase.setUserOnlineStatus();
      }
    } else if (state == AppLifecycleState.inactive) {
      await connectionUseCase.setUserOfflineStatus();
    }
  }
}

final appLifecycleProvider =
    StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>((ref) {
  return AppLifecycleNotifier();
});
