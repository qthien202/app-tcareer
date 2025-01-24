import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_cty.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_description.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_employment_type.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_location.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_title.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_type_work_space.dart';
import 'package:app_tcareer/src/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateJobPage extends ConsumerStatefulWidget {
  final JobModel? jobModel;
  const CreateJobPage({super.key, this.jobModel});

  @override
  ConsumerState<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends ConsumerState<CreateJobPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(createJobControllerProvider);
      if (widget.jobModel != null) {
        final data = widget.jobModel;
        controller.setJob(
            title: data?.title ?? "",
            jobRoleName: data?.jobRoleName,
            jobTopicName: data?.jobTopicName,
            experienceName: data?.experienceRequired != 0
                ? "${data?.experienceRequired} năm"
                : "Dưới 1 năm",
            jobRoleId: data?.jobTopicId,
            jobTopicId: data?.jobTopicId,
            experienceRequired: data?.experienceRequired,
            positionsAvailable: data?.positionsAvailable,
            employmentType: data?.employmentType,
            jobType: data?.jobType,
            expiredDate: data?.expiredDate,
            detailLocation: data?.detailLocation,
            ctyName: data?.ctyName,
            ctyImageUrl: data?.ctyImageUrl,
            jobDescription: data?.jobDescription,
            latitude: data?.latitude,
            longitude: data?.longitude);
        final location = data?.detailLocation;
        controller.setJobLocation(
            provinceName: location?.provinceName,
            provinceId: location?.provinceId,
            districtName: location?.districtName,
            districtId: location?.districtId,
            wardName: location?.wardName,
            wardId: location?.wardId,
            fullAddress: location?.fullAddress);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(createJobControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        controller.job.reset();
        context.goNamed("home");
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffF9F9F9),
        appBar: appBar(context, ref),
        body: Column(
          children: [
            AppBar(
              backgroundColor: const Color(0xffF9F9F9),
              automaticallyImplyLeading: false,
              centerTitle: false,
              leading: null,
              actions: null,
              title: Text(
                widget.jobModel != null
                    ? "Cập nhật bài đăng tuyển dụng\ncủa bạn"
                    : "Hãy tạo bài đăng tuyển dụng\ncủa bạn",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  item(
                    title: "Tiêu đề",
                    content: controller.job.title ?? "Thêm tiêu đê",
                    hasContent: controller.job.title != null,
                    onTap: () async => await controller.showBottomSheet(
                        child: const JobTitle(), context: context),
                  ),
                  item(
                      title: "Nghề nghiệp",
                      content: controller.job.jobRoleName ?? "Thêm nghề nghiệp",
                      hasContent: controller.job.jobRoleName != null,
                      onTap: () async => context.pushNamed("jobTopic")),
                  item(
                      title: "Kinh nghiệm làm việc",
                      content: controller.job.experienceName ??
                          "Thêm kinh nghiệm làm việc",
                      hasContent: controller.job.experienceName != null,
                      onTap: () async =>
                          await controller.showExperiencePicker(context)),
                  item(
                      title: "Số lượng tuyển",
                      content: controller.job.positionsAvailable != null
                          ? "${controller.job.positionsAvailable} nhân viên"
                          : "Thêm số lượng tuyển",
                      hasContent: controller.job.positionsAvailable != null,
                      onTap: () async =>
                          await controller.showEmployeeQtyPicker(context)),
                  item(
                      title: "Hình thức làm việc",
                      hasContent: controller.job.jobType != null,
                      content:
                          controller.getJobType(controller.job.jobType ?? "") ??
                              "Thêm hình thức làm việc",
                      onTap: () async => await controller.showBottomSheet(
                            context: context,
                            child: const JobTypeWorkSpace(),
                          )),
                  item(
                      title: "Địa điểm làm việc",
                      hasContent: controller.jobLocation.fullAddress != null,
                      content: controller.jobLocation.fullAddress ??
                          "Thêm địa điểm làm việc",
                      onTap: () async => context.pushNamed("jobLocation")),
                  item(
                      title: "Công ty",
                      hasContent: controller.job.ctyName != null,
                      content: controller.job.ctyName ?? "Thêm công ty",
                      onTap: () async => await controller.showBottomSheet(
                          context: context, child: const JobCty())),
                  item(
                      title: "Loại công việc",
                      hasContent: controller.job.employmentType != null,
                      content: controller.getEmploymentType(
                              controller.job.employmentType ?? "") ??
                          "Thêm loại công việc",
                      onTap: () async => await controller.showBottomSheet(
                            context: context,
                            child: const JobEmploymentType(),
                          )),
                  Visibility(
                    visible: widget.jobModel == null,
                    child: item(
                        title: "Hạn nộp hồ sơ",
                        content:
                            controller.job.expiredDate ?? "Thêm hạn nộp hồ sơ",
                        hasContent: controller.job.expiredDate != null,
                        onTap: () async => await controller
                            .showExpiredDatePicker(context: context)),
                  ),
                  item(
                    title: "Mô tả chi tiết",
                    hasContent: controller.job.jobDescription != null,
                    content: controller.job.jobDescription == null
                        ? "Thêm mô tả chi tiết"
                        : null,
                    widget: Visibility(
                      visible: controller.job.jobDescription != null,
                      // replacement: Text("Thêm mô tả chi tiết"),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: ScreenUtil().screenHeight * .3,
                            maxWidth: ScreenUtil().screenWidth * .8),
                        child: ListView(
                          children: [
                            HtmlWidget(
                              controller.job.jobDescription ?? "",
                              textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async => context.pushNamed("jobDescription"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: widget.jobModel != null,
                replacement: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: controller.validateJobModel() == true
                        ? () async {
                            await controller.postCreateJob(context);
                          }
                        : null,
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Đăng bài",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: controller.validateJobModel() == true
                        ? () async {
                            await controller.putUpdateJob(
                                context: context,
                                jobId: widget.jobModel?.id ?? 0);
                          }
                        : null,
                    child: const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Cập nhật",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
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
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 2),
      //     child: TextButton(
      //         // style: ElevatedButton.styleFrom(
      //         //     shape: RoundedRectangleBorder(
      //         //         borderRadius: BorderRadius.circular(20)),
      //         //     backgroundColor: AppColors.executeButton),
      //         onPressed: () async {
      //           if (controller.validateJobModel() == false) {
      //             await AlertDialogUtil.showAlert(
      //                 context: context,
      //                 title: "Thông báo",
      //                 content: "Vui lòng hoàn thành đầy đủ thông tin!");
      //             return;
      //           }
      //           await controller.postCreateJob(context);
      //         },
      //         child: Text(
      //           "Đăng bài",
      //           style: TextStyle(
      //               color: AppColors.executeButton,
      //               fontSize: 14,
      //               fontWeight: FontWeight.bold),
      //         )),
      //   )
      // ],
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
}
