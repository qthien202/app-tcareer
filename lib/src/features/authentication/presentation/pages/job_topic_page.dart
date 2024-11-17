import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/job_topic_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobTopicPage extends ConsumerWidget {
  const JobTopicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(jobTopicControllerProvider);
    if (controller.jobTopics.isEmpty) {
      Future.microtask(() async {
        await controller.getJobTopic();
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () => context.pop(),
        //   icon: const Icon(Icons.arrow_back),
        // ),
        title: const Text(
          "Lĩnh vực quan tâm",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await controller.cancelSetTopic();
                context.goNamed("home");
              },
              child: Text(
                "Bỏ qua",
                style: TextStyle(color: Colors.grey.shade400),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lưu ý: Bạn chỉ được chọn tối đa 5 lĩnh vực",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.jobTopics.map((topic) {
                  return GestureDetector(
                    onTap: () => controller.selectTopic(topic.id ?? 0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: controller.selectedTopics.contains(topic.id)
                              ? AppColors.authButton
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: controller.selectedTopics.contains(topic.id)
                              ? null
                              : Border.all(color: Colors.grey.shade300)),
                      child: Text(
                        topic.topicName ?? "",
                        style: TextStyle(
                            color: controller.selectedTopics.contains(topic.id)
                                ? Colors.white
                                : Colors.grey),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: controller.selectedTopics.isNotEmpty
                ? () async => await controller.addJobTopic(context)
                : null,
            child: Text(
              "Lưu lại",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
