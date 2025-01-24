import 'package:app_tcareer/src/features/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

enum RegisterType { phone, email }

class RegisterPage extends ConsumerWidget {
  final RegisterType type;
  const RegisterPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(registerControllerProvider);
    // controller.fullNameController.text = "thien test";
    // controller.emailController.text = "huathien1303@gmail.com";
    // controller.passController.text = "123456aA@";
    // controller.confirmPasswordController.text = "123456aA@";

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
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextInputForm(
                          isRequired: true,
                          controller: controller.fullNameController,
                          // isRequired: true,
                          title: "Họ tên",
                          hintText: "Nhập họ tên",
                          validator: Validator.fullname,
                        ),
                        Visibility(
                          visible: type != RegisterType.phone,
                          child: TextInputForm(
                            controller: controller.emailController,
                            isRequired: true,
                            title: "Email",
                            hintText: "Nhập email",
                            validator: Validator.email,
                          ),
                        ),
                        TextInputForm(
                          isRequired: true,
                          validator: Validator.password,
                          controller: controller.passController,
                          // isRequired: true,
                          isSecurity: true,
                          title: "Mật khẩu",
                          hintText: "Nhập mật khẩu",
                        ),
                        TextInputForm(
                          isRequired: true,
                          isSecurity: true,
                          controller: controller.confirmPasswordController,
                          // isRequired: true,
                          title: "Xác nhận mật khẩu",
                          hintText: "Nhập lại mật khẩu",
                          validator: (val) {
                            return Validator.rePassword(
                                val, controller.passController.text);
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        authButtonWidget(
                            context: context,
                            onPressed: () async => controller.onCreate(
                                context: context, type: type),
                            title: "Tiếp tục"),

                        const SizedBox(
                          height: 20,
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 50,
                        //   child: SignInButton(Buttons.google,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(6)),
                        //       onPressed: () =>
                        //           controller.signInWithGoogle(context)),
                        // ),
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
