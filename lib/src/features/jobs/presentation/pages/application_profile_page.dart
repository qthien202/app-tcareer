import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/index/index_page.dart';
import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/apply_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/cv_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/text_input.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'job_detail_page.dart';

class ApplicationProfilePage extends ConsumerStatefulWidget {
  final num? jobId;

  const ApplicationProfilePage({
    super.key,
    this.jobId,
  });

  @override
  ConsumerState<ApplicationProfilePage> createState() =>
      _ApplicationProfilePageState();
}

class _ApplicationProfilePageState
    extends ConsumerState<ApplicationProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      controller.applicationProfile = null;
      if (widget.jobId != null) {
        await controller.getApplicationProfile(widget.jobId ?? 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(applyJobControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Hồ sơ ứng tuyển",
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
    );
  }

  // Widget bottomApplicant(
  //     {required BuildContext context, required WidgetRef ref}) {
  //   final userController = ref.watch(userControllerProvider);
  //   final controller = ref.watch(jobControllerProvider);
  //   final application = controller.application;
  //   return BottomAppBar(
  //     color: Colors.white,
  //     child: Row(
  //       // crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         GestureDetector(
  //           onTap: () async {
  //             String clientId =
  //                 userController.userData?.data?.id.toString() ?? "";
  //             context.pushNamed("jobChat", pathParameters: {
  //               "userId": application?.userId.toString() ?? "",
  //               "clientId": clientId
  //             });
  //           },
  //           child: Container(
  //             padding: EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               shape: BoxShape.circle,
  //               border: Border.all(color: Colors.grey.shade200),
  //             ),
  //             child: const PhosphorIcon(
  //               PhosphorIconsRegular.chatCenteredDots,
  //               color: AppColors.primary,
  //               size: 25,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Expanded(
  //             flex: 4,
  //             child: Visibility(
  //               child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8)),
  //                       backgroundColor: AppColors.primary,
  //                       padding: const EdgeInsets.symmetric(vertical: 15)),
  //                   onPressed: () => context.pushNamed("profile",
  //                       queryParameters: {
  //                         "userId": application?.userId.toString() ?? ""
  //                       }),
  //                   child: const Text(
  //                     "Xem trang cá nhân",
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14),
  //                   )),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  Widget userInformation(WidgetRef ref) {
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    final controller = ref.watch(jobControllerProvider);
    final application = controller.applicationProfile;
    emailController.text = application?.email.toString() ?? "";
    phoneController.text = application?.phone.toString() ?? "";

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(application?.avatar ?? ""),
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
                    application?.fullName ?? "",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  // Text(
                  //   "Lập trình viên",
                  //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  // )
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
    final jobController = ref.watch(jobControllerProvider);
    final application = jobController.applicationProfile;
    final userController = ref.watch(userControllerProvider);
    String? cvFile = application?.cvFile ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: ScreenUtil().screenWidth,
      height: controller.selectedFile != null
          ? 100
          : application != null
              ? 60
              : 300,
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
                  Visibility(
                    visible: application == null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CV tải lên gần đây",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  fileItemRecent(context: context, url: cvFile),
                  Visibility(
                    visible: application == null,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                ],
              )),
          Visibility(
            visible: application == null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              width: 10,
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
          ],
        ),
      ),
    );
  }
}
