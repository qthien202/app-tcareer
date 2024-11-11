import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobEmployeeQty extends ConsumerWidget {
  const JobEmployeeQty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(createJobControllerProvider);
    List<Map<String, dynamic>> numberOfEmployees = [
      {
        "value": 1,
        "title": "1 nhân viên",
      },
      {
        "value": 2,
        "title": "2 nhân viên",
      },
      {
        "value": 3,
        "title": "3 nhân viên",
      },
      {
        "value": 4,
        "title": "4 nhân viên",
      },
      {
        "value": 5,
        "title": "5 nhân viên",
      },
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: 250,
        child: Column(
          children: [
            Material(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn số lượng tuyển',
                      style: TextStyle(
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (controller.job.positionsAvailable == null) {
                          int value = numberOfEmployees.first['value'];
                          await controller.setJob(positionsAvailable: value);
                        }
                        context.pop();
                      },
                      child: const Text(
                        'Xong',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 32.0,
                // scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                onSelectedItemChanged: (index) async {
                  int value = numberOfEmployees[index]['value'];

                  await controller.setJob(positionsAvailable: value);
                },
                children: numberOfEmployees
                    .map((employee) => Center(child: Text(employee['title'])))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
