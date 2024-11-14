import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/apply_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/cv_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ApplyJobPage extends ConsumerWidget {
  const ApplyJobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(applyJobControllerProvider);
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
          Text(
            "CV ứng tuyển",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          cvItem(ref, context),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: controller.selectedFile != null
                  ? () async {
                      await controller.uploadFile(context);
                    }
                  : null,
              child: Text(
                "Tải CV lên",
                style: TextStyle(color: Colors.white),
              )),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () => context.pushNamed('viewCV',
                  extra: PdfModel(
                      url:
                          "https://firebasestorage.googleapis.com/v0/b/tcareer-4fa7d.appspot.com/o/cv%2F6d21eb7b-5d6c-451b-aadf-746b99082de8%2Fc046a1e6-26a5-48e6-8ba8-e4169f4679ef?alt=media&token=b6246f1d-b3ce-427c-8dc9-fde4b30f267a")),
              child: Text("Mở cv"))
        ],
      ),
    );
  }

  Widget cvItem(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(applyJobControllerProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: ScreenUtil().screenWidth,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
                  radius: Radius.circular(8),
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
                          PhosphorIconsFill.fileArrowUp,
                          color: Colors.blue,
                          size: 28,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Nhấn để tải lên",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
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
                context: context),
          )
        ],
      ),
    );
  }

  Widget fileItem(
      {File? file, required String fileName, required BuildContext context}) {
    return InkWell(
      onTap: () => context.pushNamed("viewCV",
          extra: PdfModel(file: file, fileName: fileName)),
      child: Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            PhosphorIcon(
              PhosphorIconsFill.filePdf,
              color: Colors.redAccent,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              fileName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
