import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostedJobUser extends ConsumerStatefulWidget {
  const PostedJobUser({super.key});

  @override
  ConsumerState<PostedJobUser> createState() => _PostedJobUserState();
}

class _PostedJobUserState extends ConsumerState<PostedJobUser> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.read(userControllerProvider);
      scrollController.addListener(() {
        controller.loadPostedJobMore(scrollController);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userControllerProvider);
    bool hasData = controller.postedJobs.isNotEmpty;
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => await controller.getPostedJob(),
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
    final controller = ref.watch(userControllerProvider);
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
              return jobItem(job, context);
            },
          ),
        ),
      ),
    );
  }
}
