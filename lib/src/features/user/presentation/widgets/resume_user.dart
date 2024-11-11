import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ResumeUser extends ConsumerWidget {
  const ResumeUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createResumeControllerProvider);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      children: [
        item(
            title: "Giới thiệu",
            content: "Thêm giới thiệu bản thân",
            onTap: () {
              final model = CreateResumeModel(
                textController: controller.introduceController,
                profileTopic: ProfileTopic.introduce,
                title: "Giới thiệu",
                onSave: () {},
              );
              context.goNamed("createResume", extra: model);
            }),
        item(
            title: "Kinh nghiệm",
            content: "Thêm kinh nghiệm",
            onTap: () {
              final model = CreateResumeModel(
                textController: controller.experienceController,
                profileTopic: ProfileTopic.experience,
                title: "Kinh nghiệm",
                onSave: () {},
              );
              context.goNamed("createResume", extra: model);
            }),
        item(
            title: "Trình độ học vấn",
            content: "Thêm trình độ học vấn",
            onTap: () {
              final model = CreateResumeModel(
                textController: controller.educationController,
                profileTopic: ProfileTopic.education,
                title: "Trình độ học vấn",
                onSave: () {},
              );
              context.goNamed("createResume", extra: model);
            }),
        item(
            title: "Kỹ năng",
            content: "Thêm kỹ năng",
            onTap: () {
              final model = CreateResumeModel(
                textController: controller.skillController,
                profileTopic: ProfileTopic.skill,
                title: "Kỹ năng",
                onSave: () {},
              );
              context.goNamed("createResume", extra: model);
            })
      ],
    );
  }

  Widget item(
      {required String title,
      bool hasContent = false,
      void Function()? onTap,
      String? content,
      Widget? widget}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
                  visible: content != null,
                  replacement: widget ?? const Center(),
                  child: Text(
                    content ?? "",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Visibility(
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
            ),
          )
        ],
      ),
    );
  }
}
