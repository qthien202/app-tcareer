import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/presentation/auth_providers.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/auth_button_widget.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/pin_put_widget.dart';

import 'package:app_tcareer/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyPage extends ConsumerWidget {
  final VerifyOTP? verifyOTP;

  const VerifyPage({super.key, this.verifyOTP});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(forgotPasswordControllerProvider);
    final registerController = ref.watch(registerControllerProvider);

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
                  "Mã xác thực OTP",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: verifyOTP == null,
                  replacement: Visibility(
                    visible: verifyOTP?.phoneNumber != null,
                    replacement: Text(
                      "Nhập mã xác minh mà chúng tôi vừa gửi đến email của bạn ${verifyOTP?.email}",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey, letterSpacing: 1),
                    ),
                    child: Text(
                      "Nhập mã xác minh mà chúng tôi vừa gửi đến số điện thoại của bạn ${verifyOTP?.phoneNumber}",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey, letterSpacing: 1),
                    ),
                  ),
                  child: Text(
                    "Nhập mã xác minh mà chúng tôi vừa gửi đến email của bạn ${controller.textInputController.text}",
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey, letterSpacing: 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.keyVerify,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pinPutWidget(controller: controller.codeController),
                      const SizedBox(
                        height: 35,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async {
                            switch (verifyOTP?.type) {
                              case TypeVerify.registerPhone:
                                await registerController.signInWithOTP(
                                    context: context,
                                    smsCode: controller.codeController.text,
                                    verificationId:
                                        verifyOTP?.verificationId ?? "");
                                break;
                              case TypeVerify.registerEmail:
                                await registerController.verifyEmail(
                                    email:
                                        registerController.emailController.text,
                                    password: verifyOTP?.password ?? "",
                                    context: context,
                                    code: controller.codeController.text);
                              case TypeVerify.forgotPasswordPhone:
                                await controller.signInWithOTP(
                                    context: context,
                                    smsCode: controller.codeController.text,
                                    verificationId:
                                        verifyOTP?.verificationId ?? "");
                                break;
                              default:
                                await controller.verifyOtp(context);
                                break;
                            }
                          },
                          title: "Xác nhận"),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Không nhận được mã? ",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                              children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Text(
                                    "Gửi lại",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ))
                          ])),
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
