import 'package:app_tcareer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_search_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/messages_match_page.dart';
import 'package:app_tcareer/src/features/index/index_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_page.dart';
import 'package:app_tcareer/src/features/notifications/presentation/pages/notification_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/home_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/media/user_media_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/profile_page.dart';
import 'package:app_tcareer/src/routes/home_route.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';

enum RouteNames { home, jobs, notifications, user, temp }

class Index {
  static final StatefulShellRoute router = StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          IndexPage(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: "/${RouteNames.home.name}",
                name: RouteNames.home.name,
                pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const HomePage(),
                    transitionsBuilder: fadeTransitionBuilder),
                routes: HomeRoute.routes),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.jobs.name}",
            name: RouteNames.jobs.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const JobPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/${RouteNames.temp.name}",
            name: RouteNames.temp.name,
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const Text("Temp"),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/conversation",
              name: "conversation",
              pageBuilder: (context, state) {
                return const CustomTransitionPage(
                    child: ConversationPage(),
                    transitionsBuilder: fadeTransitionBuilder);
              },
              routes: [
                GoRoute(
                    path: "chat/:userId/:clientId",
                    name: "chat",
                    pageBuilder: (context, state) {
                      String userId = state.pathParameters['userId'].toString();
                      String clientId =
                          state.pathParameters['clientId'].toString();
                      String? content =
                          state.uri.queryParameters['content'].toString() ?? "";
                      return CustomTransitionPage(
                          child: ChatPage(
                            userId: userId,
                            clientId: clientId,
                            content: content,
                          ),
                          transitionsBuilder: fadeTransitionBuilder);
                    },
                    routes: []),
                GoRoute(
                    path: "search",
                    name: "conversationSearch",
                    pageBuilder: (context, state) {
                      return const CustomTransitionPage(
                          child: ConversationSearchPage(),
                          transitionsBuilder: fadeTransitionBuilder);
                    },
                    routes: [
                      GoRoute(
                          path: "match",
                          name: "messagesMatch",
                          pageBuilder: (context, state) {
                            final user = state.extra as Data;
                            return CustomTransitionPage(
                                child: MessagesMatchPage(
                                  user: user,
                                ),
                                transitionsBuilder: fadeTransitionBuilder);
                          },
                          routes: []),
                    ]),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/${RouteNames.user.name}",
              name: RouteNames.user.name,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: fadeTransitionBuilder),
              routes: [
                GoRoute(
                    path: "media",
                    name: "userMedia",
                    pageBuilder: (context, state) => CustomTransitionPage(
                        key: state.pageKey,
                        child: const UserMediaPage(),
                        transitionsBuilder: fadeTransitionBuilder),
                    routes: []),
              ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/notificaions",
            name: "notifications",
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const NotificationPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
      ]);
}
