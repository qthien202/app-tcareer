import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobFavoritePage extends ConsumerStatefulWidget {
  const JobFavoritePage({super.key});

  @override
  ConsumerState<JobFavoritePage> createState() => _JobFavoritePageState();
}

class _JobFavoritePageState extends ConsumerState<JobFavoritePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      controller.jobFavorites.clear();
      await controller.getJobFavorites();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = ref.watch(jobControllerProvider);
    bool hasData = controller.jobFavorites.isNotEmpty;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: const Text(
            "Việc làm đã lưu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [],
        ),
        body: CustomScrollView(
          controller: controller.jobFavoriteScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refreshAppliedJob(),
            ),
            postedList(ref),
            SliverToBoxAdapter(
              child: Visibility(
                visible: hasData &&
                    controller.jobFavorites.length !=
                        controller.jobFavoriteRes?.meta?.total,
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
      visible: controller.jobFavoriteRes != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.jobFavorites.isNotEmpty,
        replacementSliver: SliverToBoxAdapter(
          child: emptyWidget("Không có công việc nào!"),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.jobFavorites.length,
            (context, index) {
              final job = controller.jobFavorites[index];
              return jobItem(job, context, JobType.favorite);
            },
          ),
        ),
      ),
    );
  }
}
