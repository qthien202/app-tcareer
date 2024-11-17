import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchJobTopic extends ConsumerWidget {
  const SearchJobTopic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    if (controller.jobTopic.isEmpty) {
      Future.microtask(() async => await controller.getJobTopic());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            centerTitle: false,
            title: Text(
              "Chọn ngành nghề",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          sliverTopic(ref)
        ],
      ),
    );
  }

  Widget sliverTopic(WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.jobTopic.length,
        (context, index) {
          final topic = controller.jobTopic[index];
          bool isLastIndex = controller.jobTopic.length - index == 1;
          return CheckboxListTile(
              value: false,
// controlAffinity: ListTileControlAffinity.leading,
              title: Text(topic.topicName ?? ""),
              onChanged: (value) {});
        },
      ),
    );
  }
}
