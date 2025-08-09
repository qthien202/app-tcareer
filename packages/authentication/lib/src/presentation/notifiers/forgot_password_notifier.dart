import 'package:authentication/src/domain/auth_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:authentication/src/extensions/auth_extension.dart';
import 'package:authentication/src/data/models/check_user_phone_request.dart';
import 'package:authentication/src/data/models/forgot_password_request.dart';
import 'package:authentication/src/data/models/forgot_password_verify_request.dart';
import 'package:authentication/src/data/models/reset_password_request.dart';
import 'package:authentication/src/data/models/verify_otp.dart';
import 'package:authentication/src/data/models/verify_phone_request.dart';

import '../../domain/usecases/auth_usecase.dart';

class ForgotPasswordNotifier extends AsyncNotifier<void> {
  late final ForgotPasswordUseCase _forgotPasswordUseCase;
  late final ForgotPasswordVerifyUseCase _forgotPasswordVerifyUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;
  late final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;
  late final VerifyPhoneUseCase _verifyPhoneUseCase;
  late final CheckUserPhoneUseCase _checkUserPhoneUseCase;
  late final LoginWithOtpUseCase _loginWithOtpUseCase;

  // UI Controllers
  final textInputController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final keyVerify = GlobalKey<FormState>();
  final keyResetPassword = GlobalKey<FormState>();

  @override
  void build() {
    _forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
    _forgotPasswordVerifyUseCase =
        ref.read(forgotPasswordVerifyUseCaseProvider);
    _resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
    _verifyPhoneNumberUseCase = ref.read(verifyPhoneNumberOTPProvider);
    _verifyPhoneUseCase = ref.read(verifyPhoneNumberProvider);
    _checkUserPhoneUseCase = ref.read(checkUserPhoneUseCaseProvider);
    _loginWithOtpUseCase = ref.read(loginWithOTPUseCaseProvider);
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    final body = ForgotPasswordRequest(email: textInputController.text);

    AppUtils.loadingApi(() async {
      await _forgotPasswordUseCase(body);
      context.pushNamed('verify');
    }, context);
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (keyVerify.currentState?.validate() != true) return;

    final body = ForgotPasswordVerifyRequest(
      email: textInputController.text,
      verifyCode: codeController.text,
    );

    AppUtils.loadingApi(() async {
      await _forgotPasswordVerifyUseCase(body);
      context.pushNamed('resetPassword');
      showSnackBar("Xác thực thành công");
    }, context);
  }

  Future<void> resetPassword(BuildContext context) async {
    if (keyResetPassword.currentState?.validate() != true) return;

    final isEmail = textInputController.text.isValidEmail;
    final body = ResetPasswordRequest(
      email: isEmail ? textInputController.text : null,
      phone: isEmail ? null : textInputController.text,
      password: passwordController.text,
    );

    AppUtils.loadingApi(() async {
      await _resetPasswordUseCase(body);
      context.goNamed('login');
      showSnackBar("Cập nhật mật khẩu thành công");
    }, context);
  }

  Future<void> checkUserPhone(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    AppUtils.loadingApi(() async {
      await _checkUserPhoneUseCase
          .call(CheckUserPhoneRequest(phone: textInputController.text))
          .then((val) async {
        await AlertDialogUtil.showAlert(
          context: context,
          title: "Có lỗi xảy ra",
          content: "Số điện thoại không tồn tại trên hệ thống",
        );
      }).catchError((e) async {
        await verifyPhoneNumber(context);
      });
    }, context);
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    final phone = "+84${textInputController.text.substring(1)}";

    AppUtils.loadingApi(() async {
      await _verifyPhoneNumberUseCase(
        phoneNumber: phone,
        verificationCompleted: (_) {},
        verificationFailed: (ex) {
          AlertDialogUtil.showAlert(
            context: context,
            title: "Có lỗi xảy ra",
            content: ex.message ?? "",
          );
        },
        codeSent: (verificationId, _) {
          final verifyOTP = VerifyOTP(
            type: TypeVerify.forgotPasswordPhone,
            phoneNumber: textInputController.text,
            verificationId: verificationId,
          );
          context.pushNamed("verify", extra: verifyOTP);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    }, context);
  }

  Future<void> signInWithOTP({
    required String smsCode,
    required String verificationId,
    required BuildContext context,
  }) async {
    AppUtils.loadingApi(() async {
      await _loginWithOtpUseCase(
        smsCode: smsCode,
        verificationId: verificationId,
      ).then((val) async {
        final user = val?.user;
        await verifyPhone(
          idToken: await user?.getIdToken() ?? "",
          uid: user?.uid ?? "",
        );
        context.pushNamed('resetPassword');
        showSnackBar("Xác thực thành công");
      }).catchError((e) {
        AlertDialogUtil.showAlert(
          context: context,
          title: "Lỗi xác thực",
          content: "Mã xác thực không đúng, vui lòng thử lại sau",
        );
      });
    }, context);
  }

  Future<void> verifyPhone({
    required String idToken,
    required String uid,
  }) async {
    await _verifyPhoneUseCase(
      req: VerifyPhoneRequest(idToken: idToken, uid: uid),
    );
  }
}

final forgotPasswordNotifierProvider =
    AsyncNotifierProvider<ForgotPasswordNotifier, void>(
        () => ForgotPasswordNotifier());
