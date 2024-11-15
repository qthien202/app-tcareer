import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/apply_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';

import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JobDetailPage extends ConsumerStatefulWidget {
  final JobModel job;
  const JobDetailPage({super.key, required this.job});

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
    scrollController.addListener(() {
      setState(() {
        positionPixel = scrollController.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final controller = ref.watch(jobControllerProvider);

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Visibility(
          visible: positionPixel >= 100,
          child: Text(
            widget.job.title ?? "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: PhosphorIcon(PhosphorIconsRegular.bookmarkSimple),
            ),
          )
        ],
      ),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cachedImageWidget(
                  height: 50,
                  width: 50,
                  imageUrl: widget.job.ctyImageUrl ?? "",
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
                      widget.job.ctyName ?? "",
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
            widget.job.title ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  contentEmployee[widget.job.employmentType],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "${widget.job.experienceRequired.toString()} năm",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  contentType[widget.job.jobType] ?? "",
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
      bottomNavigationBar: bottomAppBar(context, ref),
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
        "icon": PhosphorIconsThin.calendar,
        "title": "Kinh nghiệm",
        "content": "${widget.job.experienceRequired} năm"
      },
      {
        "icon": PhosphorIconsThin.users,
        "title": "Số lượng tuyển",
        "content": "${widget.job.positionsAvailable} người"
      },
      {
        "icon": PhosphorIconsThin.briefcase,
        "title": "Loại công việc",
        "content": contentEmployee[widget.job.employmentType]
      },
      {
        "icon": PhosphorIconsThin.buildingOffice,
        "title": "Loại nơi làm việc",
        "content": contentType[widget.job.jobType]
      },
      {
        "icon": PhosphorIconsThin.mapPin,
        "title": "Địa điểm làm việc",
        "content": widget.job.detailLocation?.fullAddress
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
                      info['content'],
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
          HtmlWidget(widget.job.jobDescription ?? "")
        ],
      ),
    );
  }

  Widget bottomAppBar(BuildContext context, WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    final userId = userController.userData?.data?.id;
    final controller = ref.watch(applyJobControllerProvider);
    bool? isApplied = widget.job.isApplied;
    if (controller.isApplied == true) {
      setState(() {
        isApplied = controller.isApplied;
        controller.isApplied = false;
      });
    }
    print(">>>>>>>>>>>>isApplied: ${controller.isApplied}");

    bool isClient = userId == widget.job.userId;
    return BottomAppBar(
      color: Colors.white,
      child: Visibility(
        visible: !isClient,
        replacement: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: () => {},
            child: const Text(
              "Xóa công việc",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            )),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: Visibility(
                  visible: isApplied != true,
                  replacement: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: null,
                      child: const Text(
                        "Đã ứng tuyển",
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
                          padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: () => context.pushNamed("applyJob",
                          queryParameters: {"id": widget.job.id.toString()}),
                      child: const Text(
                        "Ứng tuyển ngay",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
