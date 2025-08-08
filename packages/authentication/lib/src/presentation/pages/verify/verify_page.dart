import 'package:authentication/src/data/models/verify_otp.dart';
import 'package:authentication/src/presentation/widgets/auth_button_widget.dart';
import 'package:authentication/src/presentation/widgets/pin_put_widget.dart';

import 'package:authentication/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../authentication.dart';

class VerifyPage extends ConsumerWidget {
  final VerifyOTP? verifyOTP;

  const VerifyPage({super.key, this.verifyOTP});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerNotifier = ref.watch(registerNotifierProvider.notifier);
    final forgotPasswordNotifier =
        ref.watch(forgotPasswordNotifierProvider.notifier);

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
                    "Nhập mã xác minh mà chúng tôi vừa gửi đến email của bạn ${forgotPasswordNotifier.textInputController.text}",
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey, letterSpacing: 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: forgotPasswordNotifier.keyVerify,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pinPutWidget(
                          controller: forgotPasswordNotifier.codeController),
                      const SizedBox(
                        height: 35,
                      ),
                      authButtonWidget(
                          context: context,
                          onPressed: () async {
                            switch (verifyOTP?.type) {
                              case TypeVerify.registerPhone:
                                await registerNotifier.signInWithOTP(
                                    context: context,
                                    smsCode: forgotPasswordNotifier
                                        .codeController.text,
                                    verificationId:
                                        verifyOTP?.verificationId ?? "");
                                break;
                              case TypeVerify.registerEmail:
                                await registerNotifier.verifyEmail(
                                    email:
                                        registerNotifier.emailController.text,
                                    password: verifyOTP?.password ?? "",
                                    context: context,
                                    code: forgotPasswordNotifier
                                        .codeController.text);
                              case TypeVerify.forgotPasswordPhone:
                                await forgotPasswordNotifier.signInWithOTP(
                                    context: context,
                                    smsCode: forgotPasswordNotifier
                                        .codeController.text,
                                    verificationId:
                                        verifyOTP?.verificationId ?? "");
                                break;
                              default:
                                await forgotPasswordNotifier.verifyOtp(context);
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
