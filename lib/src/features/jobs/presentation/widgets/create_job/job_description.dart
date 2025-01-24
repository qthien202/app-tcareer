import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/services/clip_board_service.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class JobDescription extends ConsumerWidget {
  const JobDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createJobControllerProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const Text(
            "Mô tả chi tiết",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: controller.isHtmlValid
                      ? () async {
                          await controller.saveJobDescription(context);
                        }
                      : null,
                  child: const Text(
                    "Lưu lại",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    QuillHtmlEditor(
                      onEditorCreated: () async {
                        await controller.setDescription();
                      },
                      ensureVisible: true,
                      autoFocus: true,
                      // text: "<h1>Hello</h1>This is a quill html editor example 😊",
                      controller: controller.quillController,
                      onSelectionChanged: (val) {},
                      isEnabled: true,
                      minHeight: 300,
                      hintTextAlign: TextAlign.start,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      hintTextPadding: EdgeInsets.zero,
                      textStyle: TextStyle(fontSize: 14),
                      onEditingComplete: (val) async {},
                      onTextChanged: (val) async {
                        if (val.isEmpty) {
                          controller.setIsHtmlValid(false);
                        } else {
                          controller.setIsHtmlValid(true);
                        }
                      },
                    ),
                  ],
                ),
              ),
              ToolBar.scroll(
                mainAxisSize: MainAxisSize.min,
                toolBarColor: Colors.white,
                activeIconColor: Colors.green,
                verticalDirection: VerticalDirection.down,
                // padding: const EdgeInsets.all(8),
                iconSize: 20,
                controller: controller.quillController,
              )
            ],
          ),
        )

        // Column(
        //   // controller: scrollController,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     QuillSimpleToolbar(
        //       controller: controller.quillController,
        //       configurations: const QuillSimpleToolbarConfigurations(
        //           showCodeBlock: false,
        //           showClipboardCut: false,
        //           showClipboardPaste: true,
        //           showClipboardCopy: false,
        //           showLink: false),
        //     ),
        //     Expanded(
        //       child: SingleChildScrollView(
        //         physics: const AlwaysScrollableScrollPhysics(),
        //         child: QuillEditor.basic(
        //           controller: controller.quillController,
        //           configurations: const QuillEditorConfigurations(
        //             autoFocus: true,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

        );
  }
}
