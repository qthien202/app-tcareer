import 'dart:ui';

import 'package:authentication/src/extensions/auth_extension.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../authentication.dart';

class ForgotPasswordPage extends ConsumerWidget {
  final Function(VerifyOTP data) onVerifyPhoneSuccess;
  final VoidCallback onVerifyEmailSuccess;
  const ForgotPasswordPage(
      {super.key,
      required this.onVerifyPhoneSuccess,
      required this.onVerifyEmailSuccess});

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
                          onPressed: () async => await _onForgotPassword(
                              context: context,
                              notifier: notifier,
                              onVerifyEmailSuccess: onVerifyEmailSuccess,
                              onVerifyPhoneSuccess: onVerifyPhoneSuccess),
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

  Future<void> _onForgotPassword(
      {required ForgotPasswordNotifier notifier,
      required BuildContext context,
      required Function(VerifyOTP data) onVerifyPhoneSuccess,
      required VoidCallback onVerifyEmailSuccess}) async {
    if (notifier.textInputController.text.isValidEmail) {
      AppUtils.loadingApi(() async {
        await notifier.forgotPassword(onSuccess: onVerifyEmailSuccess);
      }, context);
    } else if (notifier.textInputController.text.isValidPhoneNumber) {
      AppUtils.loadingApi(() async {
        await notifier.checkUserPhone(
          onVerifySuccess: onVerifyPhoneSuccess,
          onVerificationFailed: (ex) {
            AlertDialogUtil.showAlert(
              context: context,
              title: "Có lỗi xảy ra",
              content: ex.message ?? "",
            );
          },
          onPhoneNumberExist: () async {
            await AlertDialogUtil.showAlert(
              context: context,
              title: "Có lỗi xảy ra",
              content: "Số điện thoại không tồn tại trên hệ thống",
            );
          },
        );
      }, context);
    }
  }
}
