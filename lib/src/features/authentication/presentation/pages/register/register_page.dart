import 'package:app_tcareer/src/features/authentication/presentation/notifier/register_notifier.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum RegisterType { phone, email }

class RegisterPage extends ConsumerWidget {
  final RegisterType type;
  const RegisterPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(registerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
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
                  "Tạo tài khoản để tiếp tục!",
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
                          isRequired: true,
                          controller: notifier.fullNameController,
                          // isRequired: true,
                          title: "Họ tên",
                          hintText: "Nhập họ tên",
                          validator: Validator.fullname,
                        ),
                        Visibility(
                          visible: type != RegisterType.phone,
                          child: TextInputForm(
                            controller: notifier.emailController,
                            isRequired: true,
                            title: "Email",
                            hintText: "Nhập email",
                            validator: Validator.email,
                          ),
                        ),
                        TextInputForm(
                          isRequired: true,
                          validator: Validator.password,
                          controller: notifier.passController,
                          // isRequired: true,
                          isSecurity: true,
                          title: "Mật khẩu",
                          hintText: "Nhập mật khẩu",
                        ),
                        TextInputForm(
                          isRequired: true,
                          isSecurity: true,
                          controller: notifier.confirmPasswordController,
                          // isRequired: true,
                          title: "Xác nhận mật khẩu",
                          hintText: "Nhập lại mật khẩu",
                          validator: (val) {
                            return Validator.rePassword(
                                val, notifier.passController.text);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        authButtonWidget(
                            context: context,
                            onPressed: () async =>
                                notifier.onCreate(context: context, type: type),
                            title: "Tiếp tục"),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
