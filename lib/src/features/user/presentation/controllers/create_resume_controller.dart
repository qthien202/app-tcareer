import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

enum DatePicker { startDate, endDate }

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

  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();
  DateTime? selectedStartDate;
  Future<void> selectStartDate({required DateTime value}) async {
    final formattedDate = DateFormat('MM/yyyy').format(value);
    startDateTextController.text = formattedDate;
    selectedStartDate = value;
    notifyListeners();
  }

  DateTime? selectedEndDate;
  Future<void> selectEndDate({
    required DateTime value,
  }) async {
    final formattedDate = DateFormat('MM/yyyy').format(value);
    endDateTextController.text = formattedDate;
    selectedEndDate = value;

    notifyListeners();
  }

  Future<void> showDatePicker({
    required BuildContext context,
    required DatePicker datePicker,
  }) async {
    await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // height: 40,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn ngày ${datePicker == DatePicker.startDate ? "bắt đầu" : "kết thúc"}',
                          style: TextStyle(
                              letterSpacing: 0,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.pop();
                          },
                          child: const Text(
                            'Xong',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.monthYear,
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime(2101),
                    onDateTimeChanged: (pickedDate) async {
                      if (datePicker == DatePicker.startDate) {
                        await selectStartDate(value: pickedDate);
                      } else {
                        await selectEndDate(value: pickedDate);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController schoolTextController = TextEditingController();
  TextEditingController majorTextController = TextEditingController();
  List<EducationModel> educations = [];

  Future<void> addEduction(BuildContext context) async {
    final education = EducationModel(
        id: educations.length + 1,
        school: schoolTextController.text,
        major: majorTextController.text,
        startDate: startDateTextController.text,
        endDate: endDateTextController.text);
    educations.add(education);
    await postCreateResume(
        context: context, body: CreateResumeRequest(education: educations));
  }
}

final createResumeControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.read(userUseCaseProvider);
  final userController = ref.read(userControllerProvider);
  return CreateResumeController(userUseCase, userController);
});
