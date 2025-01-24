import 'package:app_tcareer/src/features/posts/data/models/photo_view_data.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/detail/post_detail_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/search_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/search_result_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/another_profile_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

class HomeRoute {
  static final List<RouteBase> routes = [
    GoRoute(
      path: "detail/:id",
      name: "detail",
      pageBuilder: (context, state) {
        final postId = state.pathParameters["id"] ?? "";
        final notificationType =
            state.uri.queryParameters["notificationType"] ?? "";
        print(">>>>>>>>>>>>>>>type0: ${notificationType}");
        return CustomTransitionPage(
            key: state.pageKey,
            child: PostDetailPage(
              postId,
              notificationType: notificationType,
            ),
            transitionsBuilder: fadeTransitionBuilder);
      },
    ),
    GoRoute(
      path: "search",
      name: "search",
      builder: (context, state) {
        return const SearchPage();
      },
    ),
    GoRoute(
      path: "searchResult",
      name: "searchResult",
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? "";
        return SearchResultPage(query);
      },
    ),
    GoRoute(
      path: "profile",
      name: "profile",
      pageBuilder: (context, state) {
        final userId = state.uri.queryParameters["userId"] ?? "";
        return CustomTransitionPage(
            key: state.pageKey,
            child: AnotherProfilePage(
              userId: userId,
            ),
            transitionsBuilder: fadeTransitionBuilder);
      },
    ),
  ];
}
