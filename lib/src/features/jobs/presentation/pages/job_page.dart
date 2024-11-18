import 'package:app_tcareer/src/features/jobs/data/models/jobs.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:app_tcareer/src/widgets/notification_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JobPage extends ConsumerWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(jobControllerProvider);
    bool hasData = controller.jobs.isNotEmpty;
    if (controller.jobs.isEmpty) {
      Future.microtask(() async {
        await controller.getCurrentPosition().then((val) async {
          await controller.getJobs();
        }).catchError((e) async {
          await controller.getJobs();
        });
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.jobScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refreshJob(),
            ),
            sliverAppBar(ref, context),
            sliverTab(context),
            SliverToBoxAdapter(
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: ScreenUtil().screenWidth,
              color: Colors.grey.shade100,
              height: 10,
            )),
            sliverTitle(ref),
            recommendJobs(ref),
            SliverToBoxAdapter(
              child: Visibility(
                visible: hasData &&
                    controller.jobs.length !=
                        controller.jobResponse?.meta?.total,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: circularLoadingWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverAppBar(WidgetRef ref, BuildContext context) {
    // final postingController = ref.watch(postingControllerProvider);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "Việc làm",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => context.pushNamed("searchJob"),
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
                onTap: () => context.pushNamed("notifications"),
                child: notificationIcon(ref))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => context.pushNamed("jobConversation"),
            child: const PhosphorIcon(
              PhosphorIconsRegular.chatCircleDots,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: postingController.isLoading == true
      //       ? const Size.fromHeight(30)
      //       : const Size.fromHeight(0),
      //   child: postingLoading(ref),
      // ),
    );
  }

  Widget sliverTitle(WidgetRef ref) {
    final controller = ref.watch(jobControllerProvider);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Đề xuất cho bạn",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: controller.currentLocation != null,
              child: Row(
                children: [
                  PhosphorIcon(
                    PhosphorIconsFill.mapPin,
                    color: Colors.blue,
                    size: 15,
                  ),
                  Text(
                    "${controller.currentLocation ?? ""}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recommendJobs(WidgetRef ref) {
    final controller = ref.watch(jobControllerProvider);
    print(">>>>>>>>>data: ${controller.jobs.length}");
    return SliverVisibility(
      visible: controller.jobResponse != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: controller.jobs.length,
          (context, index) {
            final job = controller.jobs[index];
            return jobItem(job, context, JobType.job);
          },
        ),
      ),
    );
  }

  Widget sliverTab(BuildContext context) {
    List<Map<String, dynamic>> tabs = [
      {
        "title": "Việc làm của tôi",
        "onTap": () => context.pushNamed("postedJob"),
      },
      {
        "title": "Việc làm đã ứng tuyển",
        "onTap": () => context.pushNamed("appliedJob"),
      },
      {
        "title": "Việc làm đã lưu",
        "onTap": () => context.pushNamed("jobFavorites")
      }
    ];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              return button(tab);
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget button(Map<String, dynamic> tab) {
    return GestureDetector(
      onTap: tab['onTap'],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          tab['title'],
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
