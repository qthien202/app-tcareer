import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:readmore/readmore.dart';

class ResumeAnother extends ConsumerWidget {
  const ResumeAnother({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(anotherUserControllerProvider);
    // final userController = ref.watch(userControllerProvider);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => await controller.refresh(),
        ),
        SliverVisibility(
            visible: controller.resumeModel?.data != null,
            replacementSliver: SliverToBoxAdapter(
              child: emptyWidget("Người dùng này chưa có thông tin"),
            ),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Visibility(
                      visible:
                          controller.resumeModel?.data?.introduction != null,
                      child: item(
                        title: "Giới thiệu",
                        widget: contentWidget(
                            controller.resumeModel?.data?.introduction ?? ""),
                      ),
                    ),
                    Visibility(
                      visible: controller.resumeModel?.data?.experience != null,
                      child: item(
                        title: "Kinh nghiệm",
                        widget: experienceList(ref),
                      ),
                    ),
                    Visibility(
                      visible: controller.resumeModel?.data?.education != null,
                      child: item(
                        title: "Trình độ học vấn",
                        widget: educationList(ref),
                      ),
                    ),
                    Visibility(
                      visible: controller.resumeModel?.data?.skills != null,
                      child: item(
                        title: "Kỹ năng",
                        widget: skillList(ref),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget item({required String title, Widget? widget}) {
    return Container(
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
                widget ?? const Center(),
              ],
            ),
          ),
        ],
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
    final controller = ref.watch(anotherUserControllerProvider);
    return Column(
      children: controller.resumeModel?.data?.education?.map((e) {
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
    final controller = ref.watch(anotherUserControllerProvider);
    return Column(
      children: controller.resumeModel?.data?.experience?.map((e) {
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
    final controller = ref.watch(anotherUserControllerProvider);
    return Column(
      children: controller.resumeModel?.data?.skills?.map((e) {
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
