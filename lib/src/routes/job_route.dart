import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/pages/job_chat_page.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/pages/job_conversation_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/applicants_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/applied_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/apply_job_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/cv_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/posted_job_page.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

class JobRoute {
  static final List<RouteBase> routes = [
    GoRoute(
        path: "posted",
        name: "postedJob",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: PostedJobPage(),
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
        path: "detail",
        name: "jobDetail",
        pageBuilder: (context, state) {
          int index = int.parse(state.uri.queryParameters['index'] ?? "");
          return CustomTransitionPage(
              key: state.pageKey,
              child: JobDetailPage(
                index: index,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "apply",
        name: "applyJob",
        pageBuilder: (context, state) {
          final jobId = num.parse(state.uri.queryParameters['id'] ?? "");
          ApplicantModel? applicant = state.extra as ApplicantModel?;
          return CustomTransitionPage(
              key: state.pageKey,
              child: ApplyJobPage(
                jobId: jobId,
                applicant: applicant,
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
