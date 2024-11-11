import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CreateResumeController extends ChangeNotifier {
  QuillEditorController introduceController = QuillEditorController();
  QuillEditorController experienceController = QuillEditorController();
  QuillEditorController educationController = QuillEditorController();
  QuillEditorController skillController = QuillEditorController();

  Future<void> setIntroduce() async {}
}

final createResumeControllerProvider = ChangeNotifierProvider((ref) {
  return CreateResumeController();
});
