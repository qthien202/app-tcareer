import 'package:app_tcareer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_search_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/messages_match_page.dart';
import 'package:app_tcareer/src/features/index/index_page.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_page.dart';
import 'package:app_tcareer/src/features/notifications/presentation/pages/notification_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/home_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/create_resume_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/media/user_media_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/profile_page.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_education.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_introduce.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/education_list.dart';
import 'package:app_tcareer/src/routes/conversation_route.dart';
import 'package:app_tcareer/src/routes/home_route.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';

import '../features/user/data/models/create_resume_model.dart';
import 'job_route.dart';
import 'user_route.dart';

enum RouteNames { home, jobs, notifications, user, temp }

class Index {
  static final StatefulShellRoute router = StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          IndexPage(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: "/",
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
              routes: JobRoute.routes),
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
              routes: ConversationRoute.routes),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/${RouteNames.user.name}",
              name: RouteNames.user.name,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                  transitionsBuilder: fadeTransitionBuilder),
              routes: UserRoute.routes),
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
