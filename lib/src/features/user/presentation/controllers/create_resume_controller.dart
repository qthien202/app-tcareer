import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CreateResumeController extends ChangeNotifier {
  final UserUseCase userUseCase;
  final UserController userController;
  CreateResumeController(this.userUseCase, this.userController);
  QuillEditorController introduceController = QuillEditorController();
  QuillEditorController experienceController = QuillEditorController();
  QuillEditorController educationController = QuillEditorController();
  QuillEditorController skillController = QuillEditorController();

  Future<void> postCreateResume(
      {required BuildContext context,
      required CreateResumeRequest body}) async {
    AppUtils.loadingApi(() async {
      await userUseCase.postCreateResume(body: body);
      await userController.getResume();
      if (context.mounted) {
        context.pop();
      }
    }, context);
  }

  bool isHtmlValid = false;
  Future<void> setIsHtmlValid(bool value) async {
    isHtmlValid = value;
    notifyListeners();
  }
}

final createResumeControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.read(userUseCaseProvider);
  final userController = ref.read(userControllerProvider);
  return CreateResumeController(userUseCase, userController);
});
