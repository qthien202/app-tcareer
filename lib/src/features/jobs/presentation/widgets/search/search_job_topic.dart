import 'package:app_tcareer/src/configs/app_colors.dart';
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
          const SliverAppBar(
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.grey.shade50,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {
                    if (controller.selectedJobTopics.isNotEmpty) {
                      controller.clearJobTopic();
                    }
                  },
                  child: Text(
                    "Bỏ chọn tất cả",
                    style: TextStyle(
                        color: controller.selectedJobTopics.isNotEmpty
                            ? Colors.black
                            : Colors.grey.shade300,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () async {
                    if (controller.selectedJobTopics.isNotEmpty) {
                      await controller.searchFromJobTopic();
                      context.pop();
                    } else {
                      await controller.refreshSearchJob();
                      context.pop();
                    }
                  },
                  child: const Text(
                    "Áp dụng",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )),
            ),
          ],
        ),
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
          // bool isLastIndex = controller.jobTopic.length - index == 1;
          return CheckboxListTile(
              value: controller.selectedJobTopics.contains(topic.id.toString()),
              activeColor: AppColors.primary,
// controlAffinity: ListTileControlAffinity.leading,
              title: Text(topic.topicName ?? ""),
              onChanged: (isSelected) async => await controller.selectJobTopic(
                  isSelected: isSelected ?? false, value: topic.id.toString()));
        },
      ),
    );
  }
}
