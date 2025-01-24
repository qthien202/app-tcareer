import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchEmploymentType extends ConsumerWidget {
  const SearchEmploymentType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    List<Map<String, dynamic>> employmentTypes = [
      {
        "value": "full-time",
        "title": "Full time",
        "subTitle": "Toàn thời gian.",
      },
      {
        "value": "part-time",
        "title": "Part time",
        "subTitle": "Bán thời gian.",
      },
      {
        "value": "contract",
        "title": "Contract",
        "subTitle": "Theo hợp đồng.",
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
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: employmentTypes.length,
            itemBuilder: (context, index) {
              final item = employmentTypes[index];
              return CheckboxListTile(
                  activeColor: AppColors.primary,
                  value: controller.selectedEmploymentTypes
                      .contains(item['value']),
                  // controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item['subTitle']),
                  onChanged: (isSelected) async =>
                      await controller.selectEmploymentType(
                          isSelected: isSelected ?? false,
                          value: item['value']));
            },
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
                        if (controller.selectedEmploymentTypes.isNotEmpty) {
                          controller.clearEmploymentType();
                        }
                      },
                      child: Text(
                        "Bỏ chọn tất cả",
                        style: TextStyle(
                            color: controller.selectedEmploymentTypes.isNotEmpty
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
                        if (controller.selectedEmploymentTypes.isNotEmpty) {
                          await controller.searchFromEmploymentType();
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
