import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobTypeBottomSheet extends ConsumerWidget {
  const JobTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createResumeControllerProvider);
    List<Map<String, dynamic>> privacies = [
      {
        "value": "onsite",
        "title": "On-site",
        "subTitle": "Làm việc tại văn phòng",
      },
      {
        "value": "hybrid",
        "title": "Hybrid",
        "subTitle": "Làm việc kết hợp tại văn phòng và từ xa",
      },
      {
        "value": "remote",
        "title": "Remote",
        "subTitle": "Làm việc từ xa",
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              width: 30,
              height: 4,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Chọn hình thức làm việc",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: privacies.length,
            itemBuilder: (context, index) {
              final item = privacies[index];
              return RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: AppColors.primary,
                value: item["title"],
                groupValue: controller.jobTypeTextController.text,
                onChanged: (value) async {
                  await controller.selectJobType(value);
                  context.pop();
                },
                title: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']),
                        Text(
                          item['subTitle'],
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 11),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
