import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostedJobPage extends ConsumerStatefulWidget {
  const PostedJobPage({super.key});

  @override
  ConsumerState<PostedJobPage> createState() => _PostedJobPageState();
}

class _PostedJobPageState extends ConsumerState<PostedJobPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      controller.postedJobs.clear();
      await controller.getPostedJob();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = ref.watch(jobControllerProvider);
    bool hasData = controller.postedJobs.isNotEmpty;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: const Text(
            "Việc làm của tôi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [],
        ),
        body: CustomScrollView(
          controller: controller.postedJobScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refreshPostedJob(),
            ),
            postedList(ref),
            SliverToBoxAdapter(
              child: Visibility(
                visible: hasData &&
                    controller.postedJobs.length !=
                        controller.postedJobRes?.meta?.total,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: circularLoadingWidget(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget postedList(WidgetRef ref) {
    final controller = ref.watch(jobControllerProvider);

    return SliverVisibility(
      visible: controller.postedJobRes != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.postedJobs.isNotEmpty,
        replacementSliver: SliverToBoxAdapter(
          child: emptyWidget("Không có công việc nào!"),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.postedJobs.length,
            (context, index) {
              final job = controller.postedJobs[index];
              return jobItem(job, context, JobType.postedJob);
            },
          ),
        ),
      ),
    );
  }
}
