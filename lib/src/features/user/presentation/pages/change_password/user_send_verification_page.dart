import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/change_password_controller.dart';
import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSendVerificationPage extends ConsumerWidget {
  const UserSendVerificationPage({super.key});

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
            child: Form(
              key: formKey,
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
                    "Vui lòng nhập email hoặc số điện thoại của bạn để xác thực",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      TextInputForm(
                        controller: controller.phoneController,
                        isRequired: true,
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
                            if (formKey.currentState?.validate() == true) {
                              await controller.verifyPhoneNumber(context);
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
