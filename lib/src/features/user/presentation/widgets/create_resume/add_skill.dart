import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/skill_model.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddSkill extends ConsumerWidget {
  final SkillModel? skill;
  const AddSkill({super.key, this.skill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createResumeControllerProvider);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        actions: [
          Visibility(
            visible: skill != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () async {},
                child: const PhosphorIcon(PhosphorIconsRegular.trashSimple),
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
              skill != null ? "Chỉnh sửa kỹ năng" : "Thêm kỹ năng",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextInputWidget(
              controller: controller.skillTextController,
              title: "Kỹ năng",
              hintText: "Nhập kỹ năng",
              validator: (val) {
                String value = val ?? "";
                if (value.isEmpty) {
                  return "Vui lòng nhập kỹ năng";
                }
                return null;
              },
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
                      await controller.addSkill(context);
                    }
                  },
                  child: Text(
                    "Lưu lại",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
