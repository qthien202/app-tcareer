import 'package:quill_html_editor/quill_html_editor.dart';

enum ProfileTopic { introduce, experience, education, skill }

class CreateResumeModel {
  String? title;
  QuillEditorController textController;
  void Function()? onSave;
  String? content;
  ProfileTopic? profileTopic;

  CreateResumeModel(
      {this.title,
      required this.textController,
      this.onSave,
      this.content,
      this.profileTopic});

  CreateResumeModel copyWith(
          {String? title,
          required QuillEditorController textController,
          void Function()? onSave,
          String? content,
          ProfileTopic? profileTopic}) =>
      CreateResumeModel(
          content: content,
          title: title,
          onSave: onSave,
          profileTopic: profileTopic,
          textController: textController);
}
