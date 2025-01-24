import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_employment_type.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_experience.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_work_space.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'job_detail_page.dart';

class SearchJobPage extends ConsumerStatefulWidget {
  const SearchJobPage({super.key});

  @override
  ConsumerState<SearchJobPage> createState() => _SearchJobPageState();
}

class _SearchJobPageState extends ConsumerState<SearchJobPage> {
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
            autofocus: false,
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                  pinned: true,
                  delegate:
                      _SliverTabHeaderDelegate(child: tabs(context, ref))),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomScrollView(
              // controller: controller.jobScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async => await controller.getSearchJob(),
                ),
                jobList(ref),
              ],
            ),
          ),
        ));
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
      visible: controller.jobRes != null,
      replacementSliver: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: circularLoadingWidget(),
        ),
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

  Widget tabs(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    List<TabItem> tabs = [
      TabItem(
        title: "Địa điểm",
        onTap: () => context.pushNamed("searchAddress"),
        isActive: controller.selectedProvinces.isNotEmpty,
      ),
      TabItem(
        title: "Ngành nghề",
        onTap: () => context.pushNamed("searchTopic"),
        isActive: controller.selectedJobTopics.isNotEmpty,
      ),
      TabItem(
        title: "Kinh nghiệm",
        onTap: () async => await controller.showBottomSheet(
          context: context,
          child: const SearchExperience(),
        ),
        isActive: controller.selectedExperiences.isNotEmpty,
      ),
      TabItem(
        title: "Hình thức làm việc",
        onTap: () async => await controller.showBottomSheet(
          context: context,
          child: const SearchWorkSpace(),
        ),
        isActive: controller.searchRequest.jobType != null,
      ),
      TabItem(
        title: "Loại công việc",
        onTap: () async => await controller.showBottomSheet(
          context: context,
          child: const SearchEmploymentType(),
        ),
        isActive: controller.searchRequest.employmentType != null,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 5),
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
    );
  }

  Widget button(TabItem tab) {
    print(">>>>>>>>isActive: ${tab.isActive}");
    return GestureDetector(
      onTap: tab.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tab.isActive
              ? Colors.transparent
              : Colors.grey.shade200.withOpacity(0.5),
          border: tab.isActive ? Border.all(color: AppColors.primary) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tab.title,
          style: TextStyle(
            color: tab.isActive ? AppColors.primary : Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SliverTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverTabHeaderDelegate({required this.child});

  @override
  double get minExtent => 50; // Chiều cao tối thiểu của header
  @override
  double get maxExtent => 50; // Chiều cao tối đa của header

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
