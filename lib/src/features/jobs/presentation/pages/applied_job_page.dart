import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppliedJobPage extends ConsumerStatefulWidget {
  const AppliedJobPage({super.key});

  @override
  ConsumerState<AppliedJobPage> createState() => _AppliedJobPageState();
}

class _AppliedJobPageState extends ConsumerState<AppliedJobPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      controller.appliedJobs.clear();
      await controller.getAppliedJob();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = ref.watch(jobControllerProvider);
    bool hasData = controller.appliedJobs.isNotEmpty;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: const Text(
            "Việc làm đã ứng tuyển",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [],
        ),
        body: CustomScrollView(
          controller: controller.appliedJobScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refreshAppliedJob(),
            ),
            postedList(ref),
            SliverToBoxAdapter(
              child: Visibility(
                visible: hasData &&
                    controller.appliedJobs.length !=
                        controller.appliedJobRes?.meta?.total,
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
      visible: controller.appliedJobRes != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.appliedJobs.isNotEmpty,
        replacementSliver: SliverToBoxAdapter(
          child: emptyWidget("Không có công việc nào!"),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.appliedJobs.length,
            (context, index) {
              final job = controller.appliedJobs[index];
              return jobItemForAppliedJob(job, context, JobType.applied);
            },
          ),
        ),
      ),
    );
  }
}
