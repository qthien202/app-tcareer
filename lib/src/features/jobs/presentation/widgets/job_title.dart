import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class JobTitle extends ConsumerWidget {
  const JobTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(createJobControllerProvider);
    TextEditingController textController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Form(
        key: formKey,
        child: Wrap(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                width: 30,
                height: 4,
              ),
            ),
            TextInputForm(
              controller: textController,
              title: "Tên công việc",
              hintText: "Nhập tên công việc",
              maxLine: 3,
              validator: (val) {
                String value = val ?? '';
                if (value.isEmpty) {
                  return "Tên công việc không được để trống";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
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
                      await controller.setJob(title: textController.text);
                      context.pop();
                    }
                  },
                  child: Text(
                    "Hoàn thành",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
