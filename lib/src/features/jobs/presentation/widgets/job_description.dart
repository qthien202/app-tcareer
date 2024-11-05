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
    return ClipRRect(
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
                    color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                width: 30,
                height: 4,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // controller: scrollController,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chi tiết công việc",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                  physics: AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
