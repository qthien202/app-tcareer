import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchExperience extends ConsumerWidget {
  const SearchExperience({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    List<Map<String, dynamic>> experiences = [
      {
        "value": "0", // Đổi từ int sang String
        "title": "Dưới 1 năm",
      },
      {
        "value": "1",
        "title": "1 năm",
      },
      {
        "value": "2",
        "title": "2 năm",
      },
      {
        "value": "3",
        "title": "3 năm",
      },
      {
        "value": "4",
        "title": "4 năm",
      },
      {
        "value": "5",
        "title": "5 năm",
      },
      {
        "value": "6",
        "title": "Trên 5 năm",
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              "Chọn kinh nghiệm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              // physics: const NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final item = experiences[index];
                return CheckboxListTile(
                    activeColor: AppColors.primary,
                    value: controller.selectedExperiences
                            .contains(item['value'].toString()) ==
                        true,
                    // controlAffinity: ListTileControlAffinity.leading,
                    title: Text(item['title']),
                    onChanged: (isSelected) async =>
                        await controller.selectExperience(
                            isSelected: isSelected ?? false,
                            value: item['value'].toString()));
              },
            ),
          ),
          BottomAppBar(
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
                        if (controller.selectedExperiences.isNotEmpty) {
                          controller.clearExperience();
                        }
                      },
                      child: Text(
                        "Bỏ chọn tất cả",
                        style: TextStyle(
                            color: controller.selectedExperiences.isNotEmpty
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
                        if (controller.selectedExperiences.isNotEmpty) {
                          await controller.searchFromExperience();
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
        ],
      ),
    );
  }
}
