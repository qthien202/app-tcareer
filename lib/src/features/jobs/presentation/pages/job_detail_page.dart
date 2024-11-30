import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/apply_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';

import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum JobType { job, postedJob, applied, favorite }

class JobDetailPage extends ConsumerStatefulWidget {
  final String jobId;
  final JobType? jobType;
  const JobDetailPage({super.key, required this.jobId, required this.jobType});

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  ScrollController scrollController = ScrollController();
  double positionPixel = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      setState(() {
        controller.job = null;
      });
      await controller.getJobDetail(widget.jobId);
    });
    scrollController.addListener(() {
      setState(() {
        positionPixel = scrollController.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(jobControllerProvider);

    Map<String, dynamic> contentEmployee = {
      "full-time": "Toàn thời gian",
      "part-time": "Bán thời gian",
      "contract": "Hợp đồng",
      "internship": "Thực tập"
    };
    Map<String, dynamic> contentType = {
      "onsite": "On-site",
      "hybrid": "Hybrid",
      "remote": "Remote"
    };
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.isFavorite = false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: [
            Visibility(
                visible: controller.job == null,
                child: circularLoadingWidget()),
            Visibility(
              visible: controller.job != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: cachedImageWidget(
                          height: 50,
                          width: 50,
                          imageUrl: controller.job?.ctyImageUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.job?.ctyName ?? "",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.job?.title ?? "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          controller.job?.jobTopicName ?? "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          controller.job?.jobRoleName ?? "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          controller.job?.employmentType != null
                              ? contentEmployee[controller.job?.employmentType]
                              : "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 5),
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //   decoration: BoxDecoration(
                      //       color: Colors.grey.shade100,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Text(
                      //     "${job?.experienceRequired != 0 ? job?.experienceRequired : "Dưới 1"} năm",
                      //     style: const TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w300),
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          controller.job?.jobType != null
                              ? contentType[controller.job?.jobType]
                              : "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  information(),
                  const SizedBox(
                    height: 10,
                  ),
                  jobDescription()
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: bottomAppBar(context, ref),
      ),
    );
  }

  Widget information() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin chung",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          jobInfo()
        ],
      ),
    );
  }

  Widget jobInfo() {
    final controller = ref.watch(jobControllerProvider);

    // DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    // DateFormat outputFormat = DateFormat("yyyy/MM/dd");
    // DateTime dateTime = inputFormat.parse(job?.expiredDate ?? "");
    // String outputDate = outputFormat.format(dateTime);
    Map<String, dynamic> contentEmployee = {
      "full-time": "Toàn thời gian",
      "part-time": "Bán thời gian",
      "contract": "Hợp đồng",
      "internship": "Thực tập"
    };
    Map<String, dynamic> contentType = {
      "onsite": "Làm việc tại văn phòng",
      "hybrid": "Kết hợp làm việc văn phòng và từ xa",
      "remote": "Làm việc từ xa"
    };

    List<Map<String, dynamic>> jobsInfo = [
      {
        "icon": PhosphorIconsThin.user,
        "title": "Người đăng tuyển",
        "content": "${controller.job?.userName}"
      },
      {
        "icon": PhosphorIconsThin.calendar,
        "title": "Kinh nghiệm",
        "content":
            "${controller.job?.experienceRequired != 0 ? controller.job?.experienceRequired : "Dưới 1"} năm"
      },
      {
        "icon": PhosphorIconsThin.users,
        "title": "Số lượng tuyển",
        "content": "${controller.job?.positionsAvailable} người"
      },
      {
        "icon": PhosphorIconsThin.briefcase,
        "title": "Loại công việc",
        "content": controller.job?.employmentType != null
            ? contentEmployee[controller.job?.employmentType]
            : null
      },
      {
        "icon": PhosphorIconsThin.buildingOffice,
        "title": "Hình thức làm việc",
        "content": controller.job?.jobType != null
            ? contentType[controller.job?.jobType]
            : null
      },
      {
        "icon": PhosphorIconsThin.mapPin,
        "title": "Địa điểm làm việc",
        "content": controller.job?.detailLocation?.fullAddress
      },
      {
        "icon": PhosphorIconsThin.clock,
        "title": "Hạn nộp hồ sơ",
        "content": controller.job?.expiredDate != null
            ? AppUtils.formatDate(controller.job?.expiredDate ?? "")
            : null
      },
    ];
    return Column(
      children: jobsInfo.map((info) {
        return informationItem(info);
      }).toList(),
    );
  }

  Widget informationItem(Map<String, dynamic> info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhosphorIcon(
            info['icon'],
            size: 28,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['title'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  children: [
                    Text(
                      info['content'] ?? "",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget jobDescription() {
    final controller = ref.watch(jobControllerProvider);
    final job = controller.job;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chi tiết tin tuyển dụng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          HtmlWidget(job?.jobDescription ?? "")
        ],
      ),
    );
  }

  Widget bottomAppBar(BuildContext context, WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    final userId = userController.userData?.data?.id;
    final controller = ref.watch(applyJobControllerProvider);
    final jobController = ref.watch(jobControllerProvider);
    final job = jobController.job;

    controller.isApplied = job?.isApplied ?? false;

    bool isClient = userId == job?.userId;
    return BottomAppBar(
      color: Colors.white,
      child: Visibility(
        visible: jobController.job != null,
        child: Visibility(
          visible: !isClient,
          replacement: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15)),
              onPressed: () {
                context.pushNamed("applicants",
                    queryParameters: {"id": job?.id.toString()});
              },
              child: const Text(
                "Xem danh sách ứng viên",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              )),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  String clientId =
                      userController.userData?.data?.id.toString() ?? "";
                  context.pushNamed("jobChat", pathParameters: {
                    "userId": job?.userId.toString() ?? "",
                    "clientId": clientId
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const PhosphorIcon(
                    PhosphorIconsRegular.chatCenteredDots,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 4,
                  child: Visibility(
                    visible: !(jobController
                        .isExpired(jobController.job?.expiredDate ?? "")),
                    replacement: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: null,
                        child: const Text(
                          "Hết hạn ứng tuyển",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )),
                    child: Visibility(
                      visible: controller.isApplied != true,
                      replacement: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15)),
                          onPressed: () => context.pushNamed(
                              "applicationProfile",
                              queryParameters: {"id": job?.id.toString()}),
                          child: const Text(
                            "Xem hồ sơ ứng tuyển",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15)),
                          onPressed: () => context.pushNamed("applyJob",
                              queryParameters: {"id": job?.id.toString()}),
                          child: const Text(
                            "Ứng tuyển ngay",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    final userController = ref.watch(userControllerProvider);
    final clientId = userController.userData?.data?.id;
    final controller = ref.watch(jobControllerProvider);
    final job = controller.job;
    controller.isFavorite = job?.isFavorite ?? false;
    bool isClient = clientId == job?.userId;

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      centerTitle: false,
      title: Visibility(
        visible: positionPixel >= 100,
        child: Text(
          job?.title ?? "",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      actions: [
        Visibility(
          visible: controller.job != null,
          child: Visibility(
            visible: !isClient,
            replacement: GestureDetector(
              onTap: () async => await controller.showModalJobDetail(
                  context1: context, jobModel: job ?? JobModel()),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: PhosphorIcon(PhosphorIconsRegular.dotsThreeCircle),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async => await controller.postAddJobFavorite(
                        context: context,
                        jobId: job?.id ?? 0,
                        type: widget.jobType ?? JobType.job),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: PhosphorIcon(
                        controller.isFavorite == true
                            ? PhosphorIconsFill.bookmarkSimple
                            : PhosphorIconsRegular.bookmarkSimple,
                        color: controller.isFavorite == true
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () async =>
                        await controller.shareJob(jobId: job?.id ?? 0),
                    child: PhosphorIcon(
                      PhosphorIconsRegular.shareNetwork,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
