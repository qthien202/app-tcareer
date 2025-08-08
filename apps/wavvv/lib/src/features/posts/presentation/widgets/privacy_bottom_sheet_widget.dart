import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Widget privacyBottomSheetWidget({required BuildContext context}) {
  List<Map<String, dynamic>> privacies = [
    {
      "value": "Public",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên và ngoài Tcareer",
      "icon": Icons.public
    },
    {
      "value": "Friend",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn ở Tcareer",
      "icon": Icons.group
    },
    {
      "value": "Private",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "icon": Icons.lock
    },
  ];
  return Consumer(
    builder: (context, ref, child) {
      final controller = ref.watch(postingControllerProvider);
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * .34),
        child: ClipRRect(
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
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Ai có thể nhìn thấy bài viết của bạn ?",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                      groupValue: controller.selectedPrivacy,
                      onChanged: (value) =>
                          controller.selectPrivacy(value, context),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle),
                            child: Icon(
                              item['icon'],
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
        ),
      );
    },
  );
}
