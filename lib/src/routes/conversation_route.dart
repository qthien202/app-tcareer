import 'package:app_tcareer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/conversation_search_page.dart';
import 'package:app_tcareer/src/features/chat/presentation/pages/messages_match_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

import '../features/chat/data/models/user_from_message.dart';

class ConversationRoute {
  static final List<RouteBase> routes = [
    GoRoute(
        path: "chat/:userId/:clientId",
        name: "chat",
        pageBuilder: (context, state) {
          String userId = state.pathParameters['userId'].toString();
          String clientId = state.pathParameters['clientId'].toString();
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
  ];
}
