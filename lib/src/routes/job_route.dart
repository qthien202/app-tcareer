import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/pages/job_chat_page.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/pages/job_conversation_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/applicants_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/application_profile_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/applied_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/apply_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/cv_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_favorite_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/posted_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/search_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/search_job_result_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_address.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_job_topic.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

class JobRoute {
  static final List<RouteBase> routes = [
    GoRoute(
        path: "search",
        name: "searchJob",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: SearchJobPage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
      path: "searchResult",
      name: "searchJobResult",
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? "";
        return SearchJobResultPage(
          query: query,
        );
      },
    ),
    GoRoute(
        path: "address",
        name: "searchAddress",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const SearchAddress(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "topic",
        name: "searchTopic",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const SearchJobTopic(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "posted",
        name: "postedJob",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const PostedJobPage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "applied",
        name: "appliedJob",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const AppliedJobPage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "favorites",
        name: "jobFavorites",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const JobFavoritePage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "conversations",
        name: "jobConversation",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const JobConversationPage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "chat/:userId/:clientId",
        name: "jobChat",
        pageBuilder: (context, state) {
          String userId = state.pathParameters['userId'].toString();
          String clientId = state.pathParameters['clientId'].toString();
          String? content =
              state.uri.queryParameters['content'].toString() ?? "";
          return CustomTransitionPage(
              child: JobChatPage(
                userId: userId,
                clientId: clientId,
                content: content,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "detail/:id",
        name: "jobDetail",
        pageBuilder: (context, state) {
          JobType? type = state.extra as JobType?;
          final jobId = state.pathParameters['id'] ?? "";

          return CustomTransitionPage(
              key: state.pageKey,
              child: JobDetailPage(
                jobId: jobId,
                jobType: type,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "apply",
        name: "applyJob",
        pageBuilder: (context, state) {
          num? jobId = state.uri.queryParameters['id'] != null
              ? num.parse(state.uri.queryParameters['id'] ?? "")
              : null;
          num? applicationId =
              state.uri.queryParameters['applicationId'] != null
                  ? num.parse(state.uri.queryParameters['applicationId'] ?? "")
                  : null;
          return CustomTransitionPage(
              key: state.pageKey,
              child: ApplyJobPage(
                jobId: jobId ?? 0,
                applicationId: applicationId,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "applicationProfile",
        name: "applicationProfile",
        pageBuilder: (context, state) {
          num? jobId = state.uri.queryParameters['id'] != null
              ? num.parse(state.uri.queryParameters['id'] ?? "")
              : null;
          return CustomTransitionPage(
              key: state.pageKey,
              child: ApplicationProfilePage(
                jobId: jobId ?? 0,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "applicants",
        name: "applicants",
        pageBuilder: (context, state) {
          final jobId = num.parse(state.uri.queryParameters['id'] ?? "");
          return CustomTransitionPage(
              key: state.pageKey,
              child: ApplicantsPage(
                jobId: jobId,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "viewCV",
        name: "viewCV",
        pageBuilder: (context, state) {
          final pdfModel = state.extra as PdfModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: CVPage(
                pdfModel: pdfModel,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
  ];
}
