import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWorkSpace extends ConsumerWidget {
  const SearchWorkSpace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    List<Map<String, dynamic>> workSpaces = [
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
              "Chọn loại nơi làm việc",
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
            itemCount: workSpaces.length,
            itemBuilder: (context, index) {
              final item = workSpaces[index];
              return CheckboxListTile(
                  value: false,
                  // controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item['title']),
                  onChanged: (value) {});
            },
          ),
        ],
      ),
    );
  }
}
