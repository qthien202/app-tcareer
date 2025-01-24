import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/jobs.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget jobItem(JobModel job, BuildContext context, JobType type) {
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
  return InkWell(
    onTap: () {
      context.pushNamed("jobDetail",
          pathParameters: {"id": job.id.toString()}, extra: type);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    cachedImageWidget(
                      height: 50,
                      width: 50,
                      imageUrl: job.ctyImageUrl ?? "",
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title ?? "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      job.ctyName ?? "",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${job.detailLocation?.districtName}, ${job.detailLocation?.provinceName} ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            contentEmployee[job.employmentType],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "${job.experienceRequired != 0 ? job.experienceRequired : "Dưới 1"} năm",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            contentType[job.jobType] ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: isExpired(job.expiredDate ?? ""),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Hết hạn ứng tuyển",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      AppUtils.formatTimeStatusOnline(job.updatedAt ?? ""),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )

              // Expanded(child: Text("1"))
            ],
          ),
          Visibility(
            visible: !isExpired(job.expiredDate ?? ""),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 0.5,
                color: Color(0xffEEEEEE),
                // color: Colors.grey.shade200,
              ),
            ),
          ),
          Visibility(
            visible: !isExpired(job.expiredDate ?? ""),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_filled_sharp,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Hạn nộp hồ sơ: ${AppUtils.formatDate(job.expiredDate ?? "")}",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget jobItemForAppliedJob(JobModel job, BuildContext context, JobType type) {
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
  return InkWell(
    onTap: () {
      context.pushNamed("jobDetail",
          pathParameters: {"id": job.id.toString()}, extra: type);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    cachedImageWidget(
                      height: 50,
                      width: 50,
                      imageUrl: job.ctyImageUrl ?? "",
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title ?? "",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      job.ctyName ?? "",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${job.detailLocation?.districtName}, ${job.detailLocation?.provinceName} ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            contentEmployee[job.employmentType],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "${job.experienceRequired != 0 ? job.experienceRequired : "Dưới 1"} năm",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            contentType[job.jobType] ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      AppUtils.formatTimeStatusOnline(job.updatedAt ?? ""),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )

              // Expanded(child: Text("1"))
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 0.5,
              color: Color(0xffEEEEEE),
              // color: Colors.grey.shade200,
            ),
          ),
          Visibility(
            visible: job.employerSeen == false,
            replacement: Text(
              "NTD đã xem hồ sơ (${AppUtils.formatDateTime(job.employerSeenAt ?? "")})",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w500),
            ),
            child: Text(
              "Đã ứng tuyển (${AppUtils.formatDateTime(job.appliedAt ?? "")})",
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    ),
  );
}

bool isExpired(String inputDate) {
  try {
    String dateString = AppUtils.formatDate(inputDate);
    DateTime expiredDate = DateFormat('dd/MM/yyyy').parse(dateString);
    String currentDateString = DateFormat("dd/MM/yyyy").format(DateTime.now());
    DateTime currentDate = DateFormat('dd/MM/yyyy').parse(currentDateString);

    return currentDate.isAfter(expiredDate);
  } catch (e) {
    // Nếu có lỗi (ví dụ: chuỗi không hợp lệ), trả về false
    print("Lỗi: ${e.toString()}");
    return false;
  }
}
