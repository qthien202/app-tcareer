import 'package:app_tcareer/src/features/jobs/data/models/jobs.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:app_tcareer/src/widgets/notification_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JobPage extends ConsumerWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(jobControllerProvider);
    if (controller.jobs.isEmpty) {
      Future.microtask(() async {
        await controller.getJobs();
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.getJobs(),
            ),
            sliverAppBar(ref, context),
            recommendJobs(ref)
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
        "Công việc",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {},
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
      ],
      // bottom: PreferredSize(
      //   preferredSize: postingController.isLoading == true
      //       ? const Size.fromHeight(30)
      //       : const Size.fromHeight(0),
      //   child: postingLoading(ref),
      // ),
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
            return jobItem(job);
          },
        ),
      ),
    );
  }
}
