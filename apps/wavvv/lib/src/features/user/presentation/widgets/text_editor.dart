import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

Widget textEditor(
    {required QuillEditorController quillController, required WidgetRef ref}) {
  final controller = ref.watch(createResumeControllerProvider);
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              QuillHtmlEditor(
                onEditorCreated: () async {
                  // await controller.setDescription();
                },
                ensureVisible: true,
                autoFocus: true,
                // text: "<h1>Hello</h1>This is a quill html editor example 😊",
                controller: quillController,
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
          controller: quillController,
        )
      ],
    ),
  );
}
