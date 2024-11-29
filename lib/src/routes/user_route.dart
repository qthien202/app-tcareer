import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/data/models/experience_model.dart';
import 'package:app_tcareer/src/features/user/data/models/skill_model.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/account_setting_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/change_password/change_password_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/change_password/user_verify_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/create_resume_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/edit_profile_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/change_password/user_send_verification_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/job_topic_user_page.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_education.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_experience.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_introduce.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/add_skill.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/education_list.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/experience_list.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/create_resume/skill_list.dart';
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
        path: "setting",
        name: "accountSetting",
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AccountSettingPage(),
            transitionsBuilder: fadeTransitionBuilder),
        routes: [
          GoRoute(
              path: "edit",
              name: "editProfile",
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: EditProfilePage(),
                  transitionsBuilder: fadeTransitionBuilder),
              routes: []),
          GoRoute(
            path: "changePassword/sendVerification",
            name: "sendVerification",
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const UserSendVerificationPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
              path: "changePassword/verify",
              name: "userVerification",
              pageBuilder: (context, state) {
                VerifyOTP? verifyOTp = state.extra as VerifyOTP?;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: UserVerifyPage(
                    verifyOTP: verifyOTp,
                  ),
                  transitionsBuilder: fadeTransitionBuilder,
                );
              }),
          GoRoute(
            path: "changePassword/update",
            name: "changePassword",
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ChangePasswordPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
          GoRoute(
            path: "jobTopic",
            name: "userJobTopic",
            pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const JobTopicUserPage(),
                transitionsBuilder: fadeTransitionBuilder),
          ),
        ]),
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
        path: "resume/addSkill",
        name: "addSkill",
        pageBuilder: (context, state) {
          SkillModel? skill = state.extra as SkillModel?;
          return CustomTransitionPage(
              key: state.pageKey,
              child: AddSkill(
                skill: skill,
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
        path: "resume/experience",
        name: "resumeExperience",
        pageBuilder: (context, state) {
          // final model = state.extra as CreateResumeModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: const ExperienceList(),
              transitionsBuilder: fadeTransitionBuilder);
        },
        routes: []),
    GoRoute(
        path: "resume/skill",
        name: "resumeSkill",
        pageBuilder: (context, state) {
          // final model = state.extra as CreateResumeModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: const SkillList(),
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
