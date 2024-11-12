import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/create_resume_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddIntroduce extends ConsumerStatefulWidget {
  const AddIntroduce({super.key});

  @override
  ConsumerState<AddIntroduce> createState() => _AddIntroduceState();
}

class _AddIntroduceState extends ConsumerState<AddIntroduce> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final userController = ref.watch(userControllerProvider);
      if (userController.resumeModel?.data?.introduction != "") {
        textEditingController.text =
            userController.resumeModel?.data?.introduction ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(createResumeControllerProvider);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        // title:
        // centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            Text(
              "Hãy thêm tóm tắt của bạn",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Bạn có thể viết về những năm kinh nghiệm, ngành hoặc kỹ năng của mình.",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 10,
            ),
            textInput(textEditingController),
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
                      await controller.postCreateResume(
                          context: context,
                          body: CreateResumeRequest(
                              introduction: textEditingController.text));
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

  Widget textInput(TextEditingController textEditController) {
    return TextFormField(
      // onChanged: widget.onChanged,
      // enabled: true,
      // onFieldSubmitted: widget.onSubmitted,
      validator: (val) {
        String value = val ?? "";
        if (value.isEmpty) {
          return "Vui lòng nhập tóm tắt";
        }
        if (value.length > 2600) {
          return "Tóm tắt chỉ được tối đa 2600 ký tự";
        }
        return null;
      },
      style: TextStyle(color: Colors.black),
      // obscureText: widget.isSecurity != null ? !isShowPassword : false,
      // keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 10,
      autofocus: true,
      // readOnly: widget.isReadOnly ?? false,
      controller: textEditController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 14),
        // prefixIcon: widget.prefixIcon,

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 12.0),
        labelStyle: const TextStyle(fontSize: 14.0, color: Color(0xFF2C2C2C)),
      ),
    );
  }
}
