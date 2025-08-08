import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/experience_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'employment_type_bottom_sheet.dart';
import 'job_type_bottom_sheet.dart';

class AddExperience extends ConsumerStatefulWidget {
  final ExperienceModel? experience;
  const AddExperience({super.key, this.experience});

  @override
  ConsumerState<AddExperience> createState() => _AddExperienceState();
}

class _AddExperienceState extends ConsumerState<AddExperience> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.watch(createResumeControllerProvider);
      final data = widget.experience;
      if (widget.experience != null) {
        controller.positionTextController.text = data?.position ?? "";
        controller.ctyTextController.text = data?.companyName ?? "";
        controller.employmentTypeTextController.text =
            data?.employmentType ?? "";
        controller.jobTypeTextController.text = data?.workplaceType ?? "";
        controller.startDateTextController.text = data?.startDate ?? "";
        controller.endDateTextController.text = data?.endDate ?? "";
        controller.descriptionTextController.text = data?.jobDescription ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(createResumeControllerProvider);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          // controller.clearExperience();
          formKey.currentState?.reset();
        }
      },
      child: KeyboardVisibilityBuilder(
        builder: (p0, isKeyboardVisible) {
          return Form(
            key: formKey,
            child: Scaffold(
              resizeToAvoidBottomInset: true,

              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.white,
                actions: [
                  Visibility(
                    visible: widget.experience != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () async {
                          await controller.showConfirmDeleteExperience(
                              context: context,
                              experienceId: widget.experience?.id ?? 0);
                        },
                        child: const PhosphorIcon(
                            PhosphorIconsRegular.trashSimple),
                      ),
                    ),
                  )
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  Text(
                    widget.experience != null
                        ? "Chỉnh sửa kinh nghiệm"
                        : "Thêm kinh nghiệm",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputWidget(
                    controller: controller.positionTextController,
                    title: "Chức danh",
                    hintText: "Nhập chức danh...",
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng nhập chức danh";
                      }
                      return null;
                    },
                    isRequired: true,
                  ),
                  TextInputWidget(
                    controller: controller.employmentTypeTextController,
                    title: "Loại công việc",
                    hintText: "Chọn loại công việc",
                    isRequired: true,
                    isReadOnly: true,
                    onTap: () async => await controller.showBottomSheet(
                        context: context,
                        child: const EmploymentTypeBottomSheet()),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng chọn loại công việc";
                      }
                      return null;
                    },
                  ),
                  TextInputWidget(
                      controller: controller.jobTypeTextController,
                      isReadOnly: true,
                      title: "Hình thức làm việcc",
                      hintText: "Chọn hình thức làm việc",
                      isRequired: true,
                      validator: (val) {
                        String value = val ?? "";
                        if (value.isEmpty) {
                          return "Vui lòng chọn hình thức làm việc";
                        }
                        return null;
                      },
                      onTap: () async => await controller.showBottomSheet(
                          context: context, child: const JobTypeBottomSheet()),
                      suffixIcon: const Icon(Icons.arrow_drop_down)),
                  TextInputWidget(
                    controller: controller.ctyTextController,
                    title: "Công ty hoặc tổ chức",
                    hintText: "Nhập công ty hoặc tổ chức",
                    isRequired: true,
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng nhập công ty hoặc tổ chức";
                      }
                      return null;
                    },
                  ),
                  TextInputWidget(
                    autovalidateMode: controller.selectedStartDate != null
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    controller: controller.startDateTextController,
                    isReadOnly: true,
                    title: "Ngày bắt đầu",
                    hintText: "Ngày bắt đầu...",
                    // isRequired: true,
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng nhập ngày bắt đầu";
                      }
                      if (controller.startDateTextController.text != "") {
                        if (controller.selectedEndDate != null) {
                          DateTime startDate =
                              controller.selectedStartDate ?? DateTime.now();
                          DateTime endDate =
                              controller.selectedEndDate ?? DateTime.now();
                          if (startDate.isAfter(endDate) == true) {
                            return "Ngày bắt đầu phải nhỏ hơn ngày kết thúc";
                          }
                        }
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                        onTap: () async {
                          await controller.showDatePicker(
                            context: context,
                            datePicker: DatePicker.startDate,
                          );
                        },
                        child:
                            const PhosphorIcon(PhosphorIconsRegular.calendar)),
                  ),
                  TextInputWidget(
                    autovalidateMode: controller.selectedEndDate != null
                        ? AutovalidateMode.always
                        : AutovalidateMode.onUserInteraction,
                    controller: controller.endDateTextController,
                    isReadOnly: true,
                    title: "Ngày kết thúc",
                    hintText: "Ngày kết thúc...",
                    // isRequired: true,
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng nhập ngày kết thúc";
                      }
                      if (controller.selectedStartDate != null) {
                        DateTime endDate =
                            controller.selectedEndDate ?? DateTime.now();
                        DateTime startDate =
                            controller.selectedStartDate ?? DateTime.now();
                        if (endDate.isBefore(startDate) == true) {
                          return "Ngày kết thúc phải lớn hơn ngày bắt đầu";
                        }
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                        onTap: () async {
                          await controller.showDatePicker(
                            context: context,
                            datePicker: DatePicker.endDate,
                          );
                        },
                        child:
                            const PhosphorIcon(PhosphorIconsRegular.calendar)),
                  ),
                  TextInputWidget(
                    controller: controller.descriptionTextController,
                    validator: (val) {
                      String value = val ?? "";
                      if (value.isEmpty) {
                        return "Vui lòng nhập mô tả chi tiết";
                      }
                      return null;
                    },
                    title: "Mô tả chi tiết",
                    hintText: "Nhập mô tả chi tiết",
                    isRequired: true,
                    maxLine: 5,
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // const SizedBox(
                  //   height: 30,
                  // ),
                ],
              ),
              bottomNavigationBar: isKeyboardVisible
                  ? null
                  : BottomAppBar(
                      color: Colors.white,
                      child: SizedBox(
                        height: 50,
                        width: ScreenUtil().screenWidth,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              if (formKey.currentState?.validate() == true) {
                                widget.experience != null
                                    ? await controller.updateExperience(
                                        context: context,
                                        experienceId:
                                            widget.experience?.id ?? 0)
                                    : await controller.addExperience(context);
                              }
                            },
                            child: const Text(
                              "Lưu lại",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
