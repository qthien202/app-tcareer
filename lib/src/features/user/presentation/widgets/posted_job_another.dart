import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/another_user_controller.dart';

class PostedJobAnother extends ConsumerStatefulWidget {
  const PostedJobAnother({super.key});

  @override
  ConsumerState<PostedJobAnother> createState() => _PostedJobAnotherState();
}

class _PostedJobAnotherState extends ConsumerState<PostedJobAnother> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.read(anotherUserControllerProvider);
      scrollController.addListener(() {
        controller.loadPostedJobMore(scrollController);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(anotherUserControllerProvider);
    bool hasData = controller.postedJobs.isNotEmpty;
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => await controller
              .getPostedJob(controller.anotherUserData?.data?.id ?? 0),
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
    );
  }

  Widget postedList(WidgetRef ref) {
    final controller = ref.watch(anotherUserControllerProvider);
    return SliverVisibility(
      visible: controller.postedJobRes != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.postedJobs.isNotEmpty,
        replacementSliver: SliverToBoxAdapter(
          child: emptyWidget("Người dùng này chưa đăng việc làm nào!"),
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
