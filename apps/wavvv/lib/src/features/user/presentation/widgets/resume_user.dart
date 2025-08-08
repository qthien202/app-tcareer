import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:readmore/readmore.dart';

class ResumeUser extends ConsumerWidget {
  const ResumeUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createResumeControllerProvider);
    final userController = ref.watch(userControllerProvider);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => await userController.getResume(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                item(
                    title: "Giới thiệu",
                    content: "Thêm giới thiệu bản thân",
                    hasContent:
                        userController.resumeModel?.data?.introduction != null,
                    widget: contentWidget(
                        userController.resumeModel?.data?.introduction ?? ""),
                    onTap: () {
                      context.goNamed("addIntroduce");
                    }),
                item(
                    title: "Kinh nghiệm",
                    content: "Thêm kinh nghiệm",
                    hasContent: userController
                            .resumeModel?.data?.experience?.isNotEmpty ==
                        true,
                    widget: experienceList(ref),
                    onTap: () {
                      if (userController
                              .resumeModel?.data?.experience?.isNotEmpty ==
                          true) {
                        context.goNamed("resumeExperience");
                      } else {
                        context.goNamed("addExperience");
                      }
                    }),
                item(
                    title: "Trình độ học vấn",
                    hasContent: userController
                            .resumeModel?.data?.education?.isNotEmpty ==
                        true,
                    content: "Thêm trình độ học vấn",
                    widget: educationList(ref),
                    onTap: () {
                      if (userController.resumeModel?.data?.education != null) {
                        context.goNamed("resumeEducation");
                      } else {
                        context.goNamed("addEducation");
                      }
                    }),
                item(
                    title: "Kỹ năng",
                    content: "Thêm kỹ năng",
                    widget: skillList(ref),
                    hasContent:
                        userController.resumeModel?.data?.skills?.isNotEmpty ==
                            true,
                    onTap: () {
                      userController.resumeModel?.data?.skills?.isNotEmpty ==
                              true
                          ? context.goNamed("resumeSkill")
                          : context.goNamed("addSkill");
                    })
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget item(
      {required String title,
      bool hasContent = false,
      void Function()? onTap,
      String? content,
      Widget? widget}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: hasContent == true,
                    replacement: Text(
                      content ?? "",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    child: widget ?? const Center(),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: hasContent,
              replacement: const PhosphorIcon(
                PhosphorIconsRegular.plusCircle,
                color: AppColors.primary,
                size: 28,
              ),
              child: const PhosphorIcon(
                PhosphorIconsRegular.pencilSimple,
                color: Colors.black,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentWidget(String content, {int trimLines = 5}) {
    return ReadMoreText(
      content,
      trimMode: TrimMode.Line,
      trimLines: trimLines,
      colorClickableText: Colors.black,
      trimCollapsedText: "Xem thêm",
      trimExpandedText: "Thu gọn",
      moreStyle: const TextStyle(fontWeight: FontWeight.bold),
      lessStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget educationList(WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    return Column(
      children: userController.resumeModel?.data?.education?.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PhosphorIcon(PhosphorIconsRegular.graduationCap),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.school ?? "",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Visibility(
                          visible: e.startDate != "" && e.endDate != "",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "${e.startDate} - ${e.endDate}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          e.major ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }

  Widget experienceList(WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    return Column(
      children: userController.resumeModel?.data?.experience?.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PhosphorIcon(PhosphorIconsRegular.bagSimple),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.companyName ?? "",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          e.position ?? "",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${e.employmentType} • ${e.workplaceType}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Visibility(
                          visible: e.startDate != "" && e.endDate != "",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "${e.startDate} - ${e.endDate}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        contentWidget(e.jobDescription ?? "", trimLines: 3)
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }

  Widget skillList(WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    return Column(
      children: userController.resumeModel?.data?.skills?.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PhosphorIcon(
                    PhosphorIconsFill.circle,
                    size: 8,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }
}
