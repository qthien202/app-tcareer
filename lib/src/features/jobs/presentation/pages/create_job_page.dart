import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_cty.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_description.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_employment_type.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_location.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_title.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_type_work_space.dart';
import 'package:app_tcareer/src/utils/alert_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateJobPage extends ConsumerWidget {
  const CreateJobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        context.goNamed("home");
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF9F9F9),
        appBar: appBar(context, ref),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const Text(
              "Thêm công việc",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            item(
              title: "Tiêu đề",
              content: controller.job.title,
              hasContent: controller.job.title != null,
              onTap: () async => await controller.showBottomSheet(
                  child: const JobTitle(), context: context),
            ),
            item(
                title: "Nghề nghiệp",
                content: controller.job.jobRoleName,
                hasContent: controller.job.jobRoleName != null,
                onTap: () async => context.goNamed("jobTopic")),
            item(
                title: "Kinh nghiệm làm việc",
                content: controller.job.experienceName,
                hasContent: controller.job.experienceName != null,
                onTap: () async =>
                    await controller.showExperiencePicker(context)),
            item(
                title: "Số lượng tuyển",
                content: controller.job.positionsAvailable != null
                    ? "${controller.job.positionsAvailable} nhân viên"
                    : "",
                hasContent: controller.job.positionsAvailable != null,
                onTap: () async =>
                    await controller.showEmployeeQtyPicker(context)),
            item(
                title: "Hình thức làm việc",
                hasContent: controller.job.jobType != null,
                content:
                    controller.getJobType(controller.job.jobType ?? "") ?? "",
                onTap: () async => await controller.showBottomSheet(
                      context: context,
                      child: const JobTypeWorkSpace(),
                    )),
            item(
                title: "Địa điểm làm việc",
                hasContent: controller.jobLocation.fullAddress != null,
                content: controller.jobLocation.fullAddress,
                onTap: () async => context.goNamed("jobLocation")),
            item(
                title: "Công ty",
                hasContent: controller.job.ctyName != null,
                content: controller.job.ctyName,
                onTap: () async => await controller.showBottomSheet(
                    context: context, child: const JobCty())),
            item(
                title: "Loại hình làm việc",
                hasContent: controller.job.employmentType != null,
                content: controller.getEmploymentType(
                        controller.job.employmentType ?? "") ??
                    "",
                onTap: () async => await controller.showBottomSheet(
                      context: context,
                      child: const JobEmploymentType(),
                    )),
            item(
              title: "Mô tả chi tiết",
              hasContent: controller.job.jobDescription != null,
              widget: Visibility(
                visible: controller.job.jobDescription != null,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: ScreenUtil().screenHeight * .3,
                      maxWidth: ScreenUtil().screenWidth * .8),
                  child: ListView(
                    children: [
                      HtmlWidget(
                        controller.job.jobDescription ?? "",
                        textStyle:
                            const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async => context.goNamed("jobDescription"),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),

        // bottomNavigationBar:
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);

    return AppBar(
      backgroundColor: const Color(0xffF9F9F9),
      leading: InkWell(
        onTap: () {
          context.goNamed("home");
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: TextButton(
              // style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20)),
              //     backgroundColor: AppColors.executeButton),
              onPressed: () async {
                if (controller.validateJobModel() == false) {
                  await AlertDialogUtil.showAlert(
                      context: context,
                      title: "Thông báo",
                      content: "Vui lòng hoàn thành đầy đủ thông tin!");
                  return;
                }
                await controller.postCreateJob(context);
              },
              child: Text(
                "Đăng bài",
                style: TextStyle(
                    color: AppColors.executeButton,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
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
                        fontSize: 14, fontWeight: FontWeight.bold),
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
            Visibility(
              visible: hasContent,
              replacement: const PhosphorIcon(
                PhosphorIconsRegular.plusCircle,
                color: AppColors.primary,
              ),
              child: const PhosphorIcon(
                PhosphorIconsRegular.pencilSimpleLine,
                color: AppColors.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
