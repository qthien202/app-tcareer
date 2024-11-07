import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class JobDescription extends StatelessWidget {
  const JobDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HtmlEditorController controller = HtmlEditorController();
    QuillController quillController = QuillController.basic();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Chi tiết công việc",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: null,
              child: Text(
                "Lưu",
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
          // controller: scrollController,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuillSimpleToolbar(
              controller: quillController,
              configurations: const QuillSimpleToolbarConfigurations(
                  showCodeBlock: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showClipboardCopy: false,
                  showLink: false),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: QuillEditor.basic(
                  controller: quillController,
                  configurations: const QuillEditorConfigurations(
                    autoFocus: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
