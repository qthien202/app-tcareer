import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_media_controller.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
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
    final controller = ref.watch(createJobControllerProvider);
    TextEditingController ctyNameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    if (controller.job.ctyName != null) {
      ctyNameController.text = controller.job.ctyName ?? "";
    }
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          if (controller.job.ctyImageUrl == null ||
              controller.job.ctyImageUrl !=
                  mediaController.selectedImage?.path) {
            mediaController.selectedImage = null;
          }
          print(">>>>>>>>image: ${controller.job.ctyImageUrl}");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: formKey,
          child: Wrap(
            spacing: 20,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
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
                          : Visibility(
                              visible:
                                  controller.job.ctyImageUrl?.isImageNetWork ==
                                      true,
                              replacement: Image.asset(
                                "assets/images/posts/no_image.jpg",
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              child: Image.network(
                                controller.job.ctyImageUrl ?? "",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                        right: -10,
                        bottom: -5,
                        child: InkWell(
                          onTap: () {
                            context.pop();
                            context.goNamed("jobMedia");
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  color: Colors.white,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt)),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputForm(
                controller: ctyNameController,
                title: "Tên công ty",
                hintText: "Nhập tên công ty",
                validator: (val) {
                  String value = val ?? "";
                  if (value.isEmpty) {
                    return "Vui lòng nhập tên công ty";
                  }
                  if (value.length > 100) {
                    return "Tên công ty chỉ được tối đa 100 ký tự";
                  }
                  return null;
                },
              ),
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
                    onPressed: () async {
                      if (mediaController.selectedImage == null) {
                        showSnackBarErrorException(
                            "Vui lòng chọn ảnh đại diện");
                      }
                      if (formKey.currentState?.validate() == true) {
                        await controller.setJob(
                            ctyName: ctyNameController.text,
                            ctyImageUrl: mediaController.selectedImage?.path);

                        if (context.mounted) {
                          context.pop();
                        }
                      }
                    },
                    child: const Text(
                      "Lưu lại",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
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
        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        // Gán focusNode vào TextField

        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            hintText: hintText ?? "Hôm nay bạn muốn chia sẻ điều gì?",
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}
