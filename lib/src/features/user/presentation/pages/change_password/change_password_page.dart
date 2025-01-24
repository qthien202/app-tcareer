import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/change_password_controller.dart';
import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changePasswordControllerProvider);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Đổi mật khẩu",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Tạo mật khẩu mới. Đảm bảo mật khẩu này khác với mật khẩu trước đó để đảm bảo an toàn",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextInputForm(
                        isSecurity: true,
                        controller: controller.currentPasswordController,
                        // isRequired: true,
                        title: "Mật khẩu hiện tại",
                        hintText: "Nhập mật khẩu hiện tại",
                        validator: Validator.password,
                      ),
                      TextInputForm(
                        isSecurity: true,
                        controller: controller.passwordController,
                        // isRequired: true,
                        title: "Mật khẩu",
                        hintText: "Nhập mật khẩu",
                        validator: Validator.password,
                      ),
                      TextInputForm(
                        isSecurity: true,
                        controller: controller.confirmPasswordController,
                        // isRequired: true,
                        title: "Xác nhận mật khẩu",
                        hintText: "Nhập lại mật khẩu",
                        validator: (val) {
                          return Validator.rePassword(
                              val, controller.passwordController.text);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async {
                            if (formKey.currentState?.validate() == true) {
                              await controller.changePassword(context);
                            }
                          },
                          title: "Cập nhật mật khẩu"),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
