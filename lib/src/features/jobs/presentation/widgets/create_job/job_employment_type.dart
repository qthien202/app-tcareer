import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class JobEmploymentType extends ConsumerWidget {
  const JobEmploymentType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);
    if (controller.job.employmentType != null) {
      controller.selectedJobEmploymentType = controller.job.employmentType;
    }
    List<Map<String, dynamic>> privacies = [
      {
        "value": "full-time",
        "title": "Full time",
        "subTitle": "Làm việc toàn thời gian.",
      },
      {
        "value": "part-time",
        "title": "Part time",
        "subTitle": "Làm việc bán thời gian.",
      },
      {
        "value": "contract",
        "title": "Contract",
        "subTitle": "Làm việc theo hợp đồng.",
      },
      {
        "value": "internship",
        "title": "Internship",
        "subTitle": "Thực tập",
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
              "Chọn loại công việc",
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
                value: item["value"],
                groupValue: controller.selectedJobEmploymentType,
                onChanged: (value) async {
                  await controller.selectJobEmploymentType(value);
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
