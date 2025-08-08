import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/text_input_widget.dart';
import 'package:app_tcareer/src/utils/validator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userControllerProvider);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const Text(
          "Chỉnh sửa thông tin",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(
                        controller.userData?.data?.avatar ?? ""),
                  ),
                  Positioned(
                      right: -1,
                      bottom: -1,
                      child: InkWell(
                        onTap: () {
                          // context.pop();
                          context.pushNamed("userMedia");
                        },
                        child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                color: Colors.white,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                            )),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              validator: Validator.firstName,
              controller: controller.firstNameController,
              isRequired: true,
              title: "Họ",
            ),
            TextInputWidget(
              validator: Validator.lastName,
              controller: controller.lastNameController,
              isRequired: true,
              title: "Tên",
            ),
            TextInputWidget(
              validator: Validator.email,
              controller: controller.emailController,
              isRequired: true,
              title: "Email",
            ),
            // TextInputWidget(
            //   validator: Validator.phone,
            //   controller: controller.phoneController,
            //   isRequired: true,
            //   title: "Điện thoại",
            // ),
            const SizedBox(
              height: 20,
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
                    if (formKey.currentState?.validate() == true) {
                      await controller.updateProfile(context);
                    }
                  },
                  child: Text(
                    "Cập nhật",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            // SizedBox(
            //   height: 50,
            //   width: ScreenUtil().screenWidth,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.grey.shade300,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10))),
            //       onPressed: () {},
            //       child: Text(
            //         "Đăng xuất",
            //         style: TextStyle(color: Colors.black),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
