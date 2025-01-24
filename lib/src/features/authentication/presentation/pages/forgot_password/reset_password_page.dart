import 'package:app_tcareer/src/features/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';

import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgotPasswordControllerProvider);
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
                  "Đặt mật khẩu mới",
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
                  key: controller.keyResetPassword,
                  child: Column(
                    children: [
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
                          onPressed: () async =>
                              await controller.resetPassword(context),
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
