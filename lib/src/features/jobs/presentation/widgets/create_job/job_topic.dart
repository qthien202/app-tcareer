import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class JobTopic extends ConsumerStatefulWidget {
  // final ScrollController scrollController;
  const JobTopic({super.key});

  @override
  ConsumerState<JobTopic> createState() => _JobTopicState();
}

class _JobTopicState extends ConsumerState<JobTopic> {
  final FocusNode fullAddressFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(createJobControllerProvider);
      await controller.getJobTopic();
      if (controller.job.jobTopicId != null) {
        controller.selectJobTopic(JobTopicModel(
            id: controller.job.jobTopicId,
            topicName: controller.job.jobTopicName));
        controller.selectJobRole(JobRolesModel(
            id: controller.job.jobRoleId, name: controller.job.jobRoleName));
      }
    });
  }

  @override
  void dispose() {
    fullAddressFocusNode.dispose(); // Hủy listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(createJobControllerProvider);
    return Material(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            centerTitle: false,
            actions: [
              Visibility(
                visible: controller.selectedProvince != null,
                child: TextButton(
                    onPressed: () => controller.resetAddress(),
                    child: Text(
                      "Thiết lập lại",
                      style: TextStyle(color: AppColors.primary),
                    )),
              )
            ],
            title: Text(
              "Nghề nghiệp",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: jobSelected(),
          ),
          SliverVisibility(
            visible: controller.jobOption != JobOption.none,
            sliver: titleJob(),
          ),
          SliverVisibility(
              visible: controller.jobOption != JobOption.none,
              sliver: sliverJob())
        ],
      ),
    );
  }

  Widget titleJob() {
    final controller = ref.watch(createJobControllerProvider);
    String title = controller.jobOption == JobOption.jobTopic
        ? "Nhóm nghề"
        : "Nghề nghiệp";

    return SliverAppBar(
      clipBehavior: Clip.none,
      expandedHeight: 20,
      toolbarHeight: 20,
      backgroundColor: Colors.grey.shade100,
      centerTitle: false,
      pinned: true,
      automaticallyImplyLeading: false,
      leadingWidth: 0,
      actions: null,
      title: Padding(
        padding: const EdgeInsets.only(
            bottom: 15), // Điều chỉnh khoảng cách trên nếu cần
        child: Text(
          title,
          style: TextStyle(color: Colors.black45, fontSize: 14),
        ),
      ),
    );
  }

  Widget sliverJob() {
    final controller = ref.watch(createJobControllerProvider);

    if (controller.jobOption == JobOption.jobTopic) {
      return sliverTopic();
    } else if (controller.jobOption == JobOption.jobRole) {
      return sliverRoles();
    }
    return Center();
  }

  Widget sliverRoles() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.jobRoles.length,
        (context, index) {
          final role = controller.jobRoles[index];
          bool isLastIndex = controller.jobRoles.length - index == 1;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async => await controller.selectJobRole(role),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(role.name ?? ""),
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sliverTopic() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.jobTopic.length,
        (context, index) {
          final topic = controller.jobTopic[index];
          bool isLastIndex = controller.jobTopic.length - index == 1;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async => await controller.selectJobTopic(topic),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(topic.topicName ?? ""),
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget jobSelected() {
    final controller = ref.watch(createJobControllerProvider);
    TextEditingController addressController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                controller.jobOption = JobOption.jobTopic;
              });
            },
            child: Container(
                padding: EdgeInsets.all(10),
                width: ScreenUtil().screenWidth,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: controller.jobOption == JobOption.jobTopic
                            ? AppColors.primary
                            : Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nhóm nghề",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      controller.selectedJobTopic?.topicName ??
                          "Nhấn vào để chọn",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                )),
          ),
          GestureDetector(
            onTap: controller.selectedJobTopic != null
                ? () {
                    setState(() {
                      controller.jobOption = JobOption.jobRole;
                    });
                  }
                : null,
            child: Container(
                padding: EdgeInsets.all(10),
                width: ScreenUtil().screenWidth,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: controller.jobOption == JobOption.jobRole
                            ? AppColors.primary
                            : Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nghề nghiệp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      controller.selectedJobRole?.name ?? "Nhấn vào để chọn",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: ScreenUtil().screenWidth,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: controller.selectedJobRole != null
                    ? () async {
                        await controller.setJob(
                            jobTopicId: controller.selectedJobTopic?.id,
                            jobTopicName:
                                controller.selectedJobTopic?.topicName,
                            jobRoleId: controller.selectedJobRole?.id,
                            jobRoleName: controller.selectedJobRole?.name);
                        context.pop();
                      }
                    : null,
                child: Text(
                  "Lưu lại",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget fullAddress(
      {int? minLines,
      TextEditingController? controller,
      int? maxLines,
      String? hintText,
      void Function(String)? onChanged}) {
    return SizedBox(
      height: 35,
      child: TextField(
        focusNode: fullAddressFocusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        autofocus: false,
        // minLines: minLines,
        onTap: () {},
        maxLines: maxLines,
        controller: controller,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        // Gán focusNode vào TextField
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            // hintText: hintText ?? "Hôm nay bạn muốn chia sẻ điều gì?",
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}
