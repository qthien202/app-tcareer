import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'job_detail_page.dart';

class SearchJobResultPage extends ConsumerStatefulWidget {
  final String query;
  const SearchJobResultPage({super.key, required this.query});

  @override
  ConsumerState<SearchJobResultPage> createState() =>
      _SearchJobResultPageState();
}

class _SearchJobResultPageState extends ConsumerState<SearchJobResultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(searchJobControllerProvider);
      controller.jobs.clear();
      await controller.getSearchJob();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(searchJobControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: searchBarWidget(
          onTap: () => context.pushReplacementNamed("searchJob"),
          readOnly: true,
          // onChanged: (val) async => await controller.onSearch(),
          // onSubmitted: (val) async => await controller.onSearch(),
          controller: controller.queryController,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        // controller: controller.jobScrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => await controller.getSearchJob(),
          ),
          // sliverAppBar(ref, context),
          jobList(ref),
        ],
      ),
    );
  }

  Widget jobList(WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    print(">>>>>>>>>data: ${controller.jobs.length}");
    return SliverVisibility(
      visible: controller.jobRes != null,
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
}
