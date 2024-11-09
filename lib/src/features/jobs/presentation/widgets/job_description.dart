import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/services/clip_board_service.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class JobDescription extends ConsumerStatefulWidget {
  const JobDescription({
    super.key,
  });

  @override
  ConsumerState<JobDescription> createState() => _JobDescriptionState();
}

class _JobDescriptionState extends ConsumerState<JobDescription>
    with ClipboardListener {
  @override
  void initState() {
    // TODO: implement initState
    clipboardWatcher.addListener(this);
    // start watch
    clipboardWatcher.start();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clipboardWatcher.removeListener(this);
    // stop watch
    clipboardWatcher.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            TextButton(
                onPressed: () async =>
                    await controller.saveJobDescription(context),
                child: const Text(
                  "Lưu lại",
                  style: TextStyle(
                      color: AppColors.executeButton,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )),
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

                      onEditingComplete: (val) async {},
                      onTextChanged: (val) async {
                        final clipboard = ref.read(clipboardServiceProvider);
                        final content = await clipboard.getHtmlFromClipboard();
                        if (content != null && val == content) {
                          await controller.quillController.setText(content);
                        }
                        print(">>>>>>>>>>content: $content");
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

  @override
  void onClipboardChanged() async {
    ClipboardData? newClipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    print(">>>>>>>>>>>>>>>clipboard: ${newClipboardData?.text ?? ""}");
  }
}

class PasteInputFormatter extends TextInputFormatter {
  final Function(String) onPasteDetected;

  PasteInputFormatter({required this.onPasteDetected});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text != newValue.text) {
      // Kiểm tra xem nếu dữ liệu thay đổi có thể là do paste
      onPasteDetected(newValue.text);
    }
    return newValue;
  }
}
