import 'package:app_tcareer/src/features/user/data/models/create_resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/data/models/experience_model.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/create_resume_page.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_education.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_experience.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_introduce.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/education_list.dart';
import 'package:app_tcareer/src/routes/transition_builder.dart';
import 'package:go_router/go_router.dart';

import '../features/user/presentation/pages/media/user_media_page.dart';

class UserRoute {
  static final List<RouteBase> routes = [
    GoRoute(
        path: "media",
        name: "userMedia",
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const UserMediaPage(),
            transitionsBuilder: fadeTransitionBuilder),
        routes: []),
    GoRoute(
        path: "resume/addIntroduce",
        name: "addIntroduce",
        pageBuilder: (context, state) {
          // final model = state.extra as CreateResumeModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: const AddIntroduce(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "resume/addEducation",
        name: "addEducation",
        pageBuilder: (context, state) {
          EducationModel? education = state.extra as EducationModel?;
          return CustomTransitionPage(
              key: state.pageKey,
              child: AddEducation(
                education: education,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "resume/addExperience",
        name: "addExperience",
        pageBuilder: (context, state) {
          ExperienceModel? experience = state.extra as ExperienceModel?;
          return CustomTransitionPage(
              key: state.pageKey,
              child: AddExperience(
                experience: experience,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "resume/education",
        name: "resumeEducation",
        pageBuilder: (context, state) {
          // final model = state.extra as CreateResumeModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: const EducationList(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "resume/createResume",
        name: "createResume",
        pageBuilder: (context, state) {
          final model = state.extra as CreateResumeModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: CreateResumePage(
                model: model,
              ),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
  ];
}
