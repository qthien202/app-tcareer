import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/data/models/experience_model.dart';
import 'package:app_tcareer/src/features/user/data/models/skill_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/domain/user_use_case.dart';
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

  Future<void> addEducation(BuildContext context) async {
    List<EducationModel>? educationsData =
        userController.resumeModel?.data?.education;
    final education = EducationModel(
        id: (educationsData?.length ?? 0) + 1,
        school: schoolTextController.text,
        major: majorTextController.text,
        startDate: startDateTextController.text,
        endDate: endDateTextController.text);
    if (educationsData != null) {
      educationsData.add(education);
      await postCreateResume(
          context: context,
          body: CreateResumeRequest(education: educationsData));
    } else {
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

  Future<void> updateEducation(
      {required BuildContext context, required int educationId}) async {
    List<EducationModel> educationsData =
        userController.resumeModel?.data?.education ?? [];
    final index = educationsData.indexWhere((e) => e.id == educationId);

    if (index != -1) {
      educationsData[index] = educationsData[index].copyWith(
          school: schoolTextController.text,
          major: majorTextController.text,
          startDate: startDateTextController.text,
          endDate: endDateTextController.text);

      await postCreateResume(
          context: context,
          body: CreateResumeRequest(education: educationsData));
    }
  }

  Future<void> deleteEducation(
      {required BuildContext context, required int educationId}) async {
    List<EducationModel> educationsData =
        userController.resumeModel?.data?.education ?? [];
    educationsData.removeWhere((e) => e.id == educationId);
    await postCreateResume(
        context: context, body: CreateResumeRequest(education: educationsData));
  }

  Future<void> clearEducation() async {
    schoolTextController.clear();
    majorTextController.clear();
    startDateTextController.clear();
    endDateTextController.clear();
  }

  Future<void> clearExperience() async {
    positionTextController.clear();
    ctyTextController.clear();
    employmentTypeTextController.clear();
    jobTypeTextController.clear();
    startDateTextController.clear();
    endDateTextController.clear();
    descriptionTextController.clear();
  }

  Future<void> showConfirmDeleteEducation(
      {required BuildContext context, required int educationId}) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Xóa trình độ học vấn'),
        content:
            const Text('Bạn có chắc chắn muốn xóa trình độ học vấn này không?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await deleteEducation(context: context, educationId: educationId);
              context.pop();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  TextEditingController positionTextController = TextEditingController();
  TextEditingController ctyTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController jobTypeTextController = TextEditingController();
  Future<void> selectJobType(String value) async {
    jobTypeTextController.text = value;
    notifyListeners();
  }

  TextEditingController employmentTypeTextController = TextEditingController();
  Future<void> selectEmploymentType(String value) async {
    employmentTypeTextController.text = value;
    notifyListeners();
  }

  Future<void> showBottomSheet(
      {required BuildContext context, required Widget child}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.grey.shade50,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child,
        );
      },
    );
  }

  Future<void> addExperience(BuildContext context) async {
    List<ExperienceModel>? experienceData =
        userController.resumeModel?.data?.experience;
    final experience = ExperienceModel(
        id: (experienceData?.length ?? 0) + 1,
        jobDescription: descriptionTextController.text,
        companyName: ctyTextController.text,
        employmentType: employmentTypeTextController.text,
        position: positionTextController.text,
        workplaceType: jobTypeTextController.text,
        startDate: startDateTextController.text,
        endDate: endDateTextController.text);
    if (experienceData != null) {
      experienceData.add(experience);
      await postCreateResume(
          context: context,
          body: CreateResumeRequest(experience: experienceData));
    } else {
      List<ExperienceModel> experiences = [];
      final experience = ExperienceModel(
          id: 1,
          jobDescription: descriptionTextController.text,
          companyName: ctyTextController.text,
          employmentType: employmentTypeTextController.text,
          position: positionTextController.text,
          workplaceType: jobTypeTextController.text,
          startDate: startDateTextController.text,
          endDate: endDateTextController.text);
      experiences.add(experience);
      await postCreateResume(
          context: context, body: CreateResumeRequest(experience: experiences));
    }
  }

  Future<void> updateExperience(
      {required BuildContext context, required int experienceId}) async {
    List<ExperienceModel> experienceData =
        userController.resumeModel?.data?.experience ?? [];
    final index = experienceData.indexWhere((e) => e.id == experienceId);

    if (index != -1) {
      experienceData[index] = experienceData[index].copyWith(
          jobDescription: descriptionTextController.text,
          companyName: ctyTextController.text,
          employmentType: employmentTypeTextController.text,
          position: positionTextController.text,
          workplaceType: jobTypeTextController.text,
          startDate: startDateTextController.text,
          endDate: endDateTextController.text);

      await postCreateResume(
          context: context,
          body: CreateResumeRequest(experience: experienceData));
    }
  }

  Future<void> deleteExperience(
      {required BuildContext context, required int experienceId}) async {
    List<ExperienceModel> experienceData =
        userController.resumeModel?.data?.experience ?? [];
    experienceData.removeWhere((e) => e.id == experienceId);
    await postCreateResume(
        context: context,
        body: CreateResumeRequest(experience: experienceData));
  }

  Future<void> deleteSkill(
      {required BuildContext context, required int skillId}) async {
    List<SkillModel> skillData = userController.resumeModel?.data?.skills ?? [];
    skillData.removeWhere((e) => e.id == skillId);
    await postCreateResume(
        context: context, body: CreateResumeRequest(skills: skillData));
  }

  Future<void> showConfirmDeleteExperience(
      {required BuildContext context, required int experienceId}) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Xóa kinh nghiệm'),
        content: const Text('Bạn có chắc chắn muốn xóa kinh nghiệm này không?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await deleteExperience(
                  context: context, experienceId: experienceId);
              context.pop();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  TextEditingController skillTextController = TextEditingController();
  Future<void> addSkill(BuildContext context) async {
    List<SkillModel>? skillData = userController.resumeModel?.data?.skills;
    final skill = SkillModel(
        id: (skillData?.length ?? 0) + 1, name: skillTextController.text);
    if (skillData != null) {
      skillData.add(skill);
      await postCreateResume(
          context: context, body: CreateResumeRequest(skills: skillData));
    } else {
      List<SkillModel> skills = [];
      final skill = SkillModel(id: 1, name: skillTextController.text);
      skills.add(skill);
      await postCreateResume(
          context: context, body: CreateResumeRequest(skills: skills));
    }
  }

  Future<void> updateSkill(
      {required BuildContext context, required int skillId}) async {
    List<SkillModel> skillData = userController.resumeModel?.data?.skills ?? [];
    final index = skillData.indexWhere((e) => e.id == skillId);
    if (index != -1) {
      skillData[index] =
          skillData[index].copyWith(name: skillTextController.text);
      await postCreateResume(
          context: context, body: CreateResumeRequest(skills: skillData));
    }
  }

  Future<void> showConfirmDeleteSkill(
      {required BuildContext context, required int skillId}) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Xóa kỹ năng'),
        content: const Text('Bạn có chắc chắn muốn xóa kĩ năng này không?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await deleteSkill(context: context, skillId: skillId);
              context.pop();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

final createResumeControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.read(userUseCaseProvider);
  final userController = ref.read(userControllerProvider);
  return CreateResumeController(userUseCase, userController);
});
