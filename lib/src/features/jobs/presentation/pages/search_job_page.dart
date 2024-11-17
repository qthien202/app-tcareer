import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'job_detail_page.dart';

class SearchJobPage extends ConsumerWidget {
  const SearchJobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: searchBarWidget(
          onChanged: (val) async => await controller.onSearch(),
          onSubmitted: (val) async => await controller.onSearch(),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CustomScrollView(
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
      ),
    );
  }

  Widget searchJob(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(searchJobControllerProvider);

    return Visibility(
      visible: controller.jobs.isNotEmpty == true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.jobs.length,
        itemBuilder: (context, index) {
          final job = controller.jobs[index];
          return ListTile(
            onTap: () {},
            leading: const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
            title: Text(job.title ?? ""),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }

  Widget jobList(WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    print(">>>>>>>>>data: ${controller.jobs.length}");
    return SliverVisibility(
      visible: !controller.isLoading,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.jobRes != null && controller.jobs.isEmpty,
        sliver: SliverToBoxAdapter(
          child: emptyWidget("Không tìm thấy công việc nào!"),
        ),
        replacementSliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.jobs.length,
            (context, index) {
              final job = controller.jobs[index];
              return jobItem(job, context, JobType.job);
            },
          ),
        ),
      ),
    );
  }
}
