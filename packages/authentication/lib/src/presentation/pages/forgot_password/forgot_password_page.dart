import 'package:authentication/src/extensions/auth_extension.dart';
import 'package:authentication/src/presentation/widgets/auth_button_widget.dart';
import 'package:authentication/src/presentation/widgets/text_input_form.dart';
import 'package:authentication/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../authentication.dart';

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(forgotPasswordNotifierProvider.notifier);
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
                  "Quên mật khẩu",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Vui lòng nhập email hoặc số điện thoại của bạn để đặt lại mật khẩu",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: notifier.formKey,
                  child: Column(
                    children: [
                      TextInputForm(
                        controller: notifier.textInputController,
                        // isRequired: true,
                        title: "Email hoặc số điện thoại",
                        hintText: "Nhập email hoặc số điện thoại",
                        validator: Validator.emailOrPhoneNumber,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async {
                            if (notifier
                                .textInputController.text.isValidEmail) {
                              await notifier.forgotPassword(context);
                            } else if (notifier
                                .textInputController.text.isValidPhoneNumber) {
                              await notifier.checkUserPhone(context);
                            }
                          },
                          title: "Gửi mã xác thực"),
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
