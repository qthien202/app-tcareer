import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class JobCty extends ConsumerWidget {
  const JobCty({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaController = ref.watch(jobMediaControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Wrap(
        spacing: 20,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              width: 30,
              height: 4,
            ),
          ),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: mediaController.selectedImage != null
                      ? Image.file(
                          File(mediaController.selectedImage?.path ?? ""),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/posts/no_image.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                    right: -10,
                    bottom: -5,
                    child: InkWell(
                      onTap: () => context.goNamed("jobMedia"),
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              color: Colors.white,
                              shape: BoxShape.circle),
                          child: Icon(Icons.camera_alt)),
                    )),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 40,
          // ),
          TextInputForm(
            title: "Tên công ty",
            hintText: "Nhập tên công ty",
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // TextInputForm(
          //   title: "Địa chỉ",
          //   hintText: "Nhập địa chỉ",
          // ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            width: ScreenUtil().screenWidth,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: Text(
                  "Lưu lại",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget cTyName(
      {int? minLines,
      TextEditingController? controller,
      int? maxLines,
      String? hintText,
      void Function(String)? onChanged}) {
    return SizedBox(
      height: 30,
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        autofocus: false,
        // minLines: minLines,
        onTap: () {},
        maxLines: maxLines,
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        // Gán focusNode vào TextField

        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            hintText: hintText ?? "Hôm nay bạn muốn chia sẻ điều gì?",
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}
