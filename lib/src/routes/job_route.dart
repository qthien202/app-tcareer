import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
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
              child: AppliedJobPage(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "detail",
        name: "jobDetail",
        pageBuilder: (context, state) {
          final job = state.extra as JobModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: JobDetailPage(
                job: job,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "apply",
        name: "applyJob",
        pageBuilder: (context, state) {
          final jobId = num.parse(state.uri.queryParameters['id'] ?? "");
          return CustomTransitionPage(
              key: state.pageKey,
              child: ApplyJobPage(
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
