import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobTypeWorkSpace extends ConsumerWidget {
  const JobTypeWorkSpace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);
    List<Map<String, dynamic>> privacies = [
      {
        "value": "On-site",
        "title": "On-site",
        "subTitle": "Làm việc tại văn phòng",
      },
      {
        "value": "Hybrid",
        "title": "Hybrid",
        "subTitle": "Làm việc kết hợp tại văn phòng và từ xa",
      },
      {
        "value": "Remote",
        "title": "Remote",
        "subTitle": "Làm việc từ xa",
      },
    ];
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 30,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                width: 30,
                height: 4,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Chọn loại hình làm việc",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
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
                  groupValue: controller.selectedJobTypeWorkSpace,
                  onChanged: (value) {},
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
      ),
    );
  }
}
