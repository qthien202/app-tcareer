import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddEducation extends ConsumerStatefulWidget {
  const AddEducation({super.key, this.education});
  final EducationModel? education;

  @override
  ConsumerState<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends ConsumerState<AddEducation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final controller = ref.watch(createResumeControllerProvider);
      final data = widget.education;
      if (widget.education != null) {
        controller.schoolTextController.text = data?.school ?? "";
        controller.majorTextController.text = data?.major ?? "";
        controller.startDateTextController.text = data?.startDate ?? "";
        controller.endDateTextController.text = data?.endDate ?? "";
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
          controller.clearEducation();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        // extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          actions: [
            Visibility(
              visible: widget.education != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () async => controller.showConfirmDeleteEducation(
                      context: context, educationId: widget.education?.id ?? 0),
                  child: PhosphorIcon(PhosphorIconsRegular.trashSimple),
                ),
              ),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              Text(
                widget.education != null
                    ? "Chỉnh sửa trình độ học vấn"
                    : "Thêm trình độ học vấn",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputWidget(
                controller: controller.schoolTextController,
                title: "Trường",
                hintText: "Nhập trường...",
                validator: (val) {
                  String value = val ?? "";
                  if (value.isEmpty) {
                    return "Vui lòng nhập trường";
                  }
                  if (value.length < 10) {
                    return "Trường phải bắt đầu từ 10 kí tự trở lên";
                  }
                  return null;
                },
                isRequired: true,
              ),
              TextInputWidget(
                controller: controller.majorTextController,
                title: "Chuyên ngành",
                hintText: "Nhập chuyên ngành...",
                isRequired: true,
                validator: (val) {
                  String value = val ?? "";
                  if (value.isEmpty) {
                    return "Vui lòng nhập chuyên ngành";
                  }
                  if (value.length < 10) {
                    return "Chuyên ngành phải bắt đầu từ 5 kí tự trở lên";
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
                  // String value = val ?? "";
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
                    child: const PhosphorIcon(PhosphorIconsRegular.calendar)),
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
                    child: const PhosphorIcon(PhosphorIconsRegular.calendar)),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: ScreenUtil().screenWidth,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        final educationId = widget.education?.id ?? 0;
                        await (widget.education != null
                            ? controller.updateEducation(
                                context: context, educationId: educationId)
                            : controller.addEducation(context));
                      }
                    },
                    child: const Text(
                      "Lưu lại",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
