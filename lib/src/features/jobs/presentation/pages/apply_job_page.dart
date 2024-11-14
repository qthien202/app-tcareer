import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/apply_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/cv_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/text_input.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ApplyJobPage extends ConsumerWidget {
  final num jobId;
  const ApplyJobPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(applyJobControllerProvider);
    final userController = ref.watch(userControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Ứng tuyển",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          const Text(
            "Thông tin liên hệ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          userInformation(ref),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "CV ứng tuyển",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          cvItem(ref, context),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 50,
          width: ScreenUtil().screenWidth,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: controller.selectedFile != null ||
                      userController.userData?.data?.cvFile != null
                  ? () async {
                      await controller.submitApplication(
                          jobId: jobId, context: context);
                    }
                  : null,
              child: const Text(
                "Ứng tuyển",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  Widget userInformation(WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    emailController.text = userController.userData?.data?.email ?? "";
    phoneController.text = userController.userData?.data?.phone ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        userController.userData?.data?.avatar ?? ""),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userController.userData?.data?.fullName ?? "",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Lập trình viên",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextInput(
            title: "Email",
            isReadOnly: true,
            controller: emailController,
          ),
          TextInput(
            title: "Điện thoại",
            isReadOnly: true,
            controller: phoneController,
          ),
        ],
      ),
    );
  }

  Widget cvItem(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(applyJobControllerProvider);
    final userController = ref.watch(userControllerProvider);
    String? cvFile = userController.userData?.data?.cvFile;
    String? userName = userController.userData?.data?.fullName;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: ScreenUtil().screenWidth,
      height: controller.selectedFile != null ? 100 : 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: cvFile != null && controller.selectedFile == null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CV tải lên gần đây",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fileItemRecent(context: context, url: cvFile),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
          const Text(
            "Tải CV từ điện thoại",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: controller.selectedFile != null,
            replacement: InkWell(
              onTap: () async => await controller.pickFile(),
              child: SizedBox(
                width: ScreenUtil().screenWidth,
                height: 140,
                child: DottedBorder(
                  color: Colors.blue,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
                          PhosphorIconsFill.fileArrowUp,
                          color: Colors.blue,
                          size: 28,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Nhấn để tải lên",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Hỗ trợ định dạng .pdf",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            child: fileItem(
              fileName: controller.fileName ?? "",
              file: controller.selectedFile,
              context: context,
              onDelete: () => controller.removeFile(),
            ),
          )
        ],
      ),
    );
  }

  Widget fileItem(
      {File? file,
      required String fileName,
      required BuildContext context,
      void Function()? onDelete}) {
    return InkWell(
      onTap: () => context.pushNamed("viewCV",
          extra: PdfModel(file: file, fileName: fileName)),
      child: Container(
        padding: const EdgeInsets.all(5),
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PhosphorIcon(
              PhosphorIconsFill.filePdf,
              color: Colors.redAccent,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }

  Widget fileItemRecent(
      {String? url, required BuildContext context, void Function()? onDelete}) {
    Uri uri = Uri.parse(url ?? "");
    String path = Uri.decodeComponent(uri.path);
    String fileName = path.split('/').last;
    print(">>>>>>>>>>fileName: $fileName");
    return InkWell(
      onTap: () => context.pushNamed("viewCV",
          extra: PdfModel(url: url, fileName: fileName)),
      child: Container(
        padding: const EdgeInsets.all(5),
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const PhosphorIcon(
              PhosphorIconsFill.filePdf,
              color: Colors.redAccent,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
