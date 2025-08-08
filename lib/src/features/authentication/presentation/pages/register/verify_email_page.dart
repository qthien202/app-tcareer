import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/utils/validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifier/register_notifier.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(registerNotifierProvider.notifier);
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
                  "Tạo tài khoản",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Nhập email của bạn để nhận mã xác thực qua email",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: notifier.formKeyVerifyEmail,
                  child: Column(
                    children: [
                      TextInputForm(
                        controller: notifier.emailController,
                        // isRequired: true,
                        title: "Email",
                        hintText: "Nhập email",
                        validator: Validator.email,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async {
                            await notifier.sendEmailVerification(context);
                          },
                          title: "Gửi mã xác thực"),
                      const SizedBox(
                        height: 20,
                      ),
                      authOtherButton(
                          context: context,
                          onPressed: () async {
                            context.replaceNamed("verifyPhone");
                          },
                          title: "Đăng ký số điện thoại"),
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
