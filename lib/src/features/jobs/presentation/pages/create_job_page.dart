import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_cty.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_description.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_employment_type.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_location.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_position.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_title.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_type_work_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CreateJobPage extends ConsumerWidget {
  const CreateJobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF9F9F9),
      appBar: appBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Text(
            "Tạo công việc",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          item(
            title: "Tiêu đề",
            content: "Lập trình viên",
            onTap: () async => await controller.showBottomSheet(
                child: JobTitle(), context: context),
          ),
          item(
            title: "Vị trí công việc",
            content: "Lập trình viên",
            onTap: () async => await controller.showBottomSheetDraggable(
                builder: (scrollController) =>
                    JobPosition(scrollController: scrollController),
                context: context),
          ),
          item(
              title: "Loại hình làm việc",
              content: "On-site",
              onTap: () async => await controller.showBottomSheet(
                    context: context,
                    child: const JobTypeWorkSpace(),
                  )),
          item(
              title: "Địa điểm làm việc",
              content: "Ninh Kiều, Cần Thơ",
              onTap: () async => context.goNamed("jobLocation")),
          item(
              title: "Công ty",
              content: "TTech",
              onTap: () async => await controller.showBottomSheetDraggable(
                    context: context,
                    builder: (scrollController) => JobCty(
                      scrollController: scrollController,
                    ),
                  )),
          item(
              title: "Hình thức làm việc",
              content: "Fulltime",
              onTap: () async => await controller.showBottomSheet(
                    context: context,
                    child: SizedBox(
                        height: ScreenUtil().screenHeight * .35,
                        child: const JobEmploymentType()),
                  )),
          item(
              title: "Chi tiết",
              content: "",
              onTap: () async => await controller.showBottomSheet(
                    context: context,
                    child: SizedBox(
                        height: ScreenUtil().screenHeight * .95,
                        child: JobDescription()),
                  ))
        ],
      ),

      // bottomNavigationBar:
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffF9F9F9),
      leading: InkWell(
        onTap: () {
          context.pop();
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
              onPressed: null,
              child: Text(
                "Đăng",
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
      {required String title, void Function()? onTap, String? content}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  content ?? "",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            PhosphorIcon(
              PhosphorIconsRegular.plusCircle,
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
