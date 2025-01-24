import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/extensions/auth_extension.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/usecases/forgot_password_use_case.dart';
import 'package:app_tcareer/src/features/authentication/usecases/register_use_case.dart';
import 'package:app_tcareer/src/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController extends StateNotifier<void> {
  final ForgotPasswordUseCase forgotPasswordUseCaseProvider;
  final RegisterUseCase registerUseCaseProvider;
  ForgotPasswordController(
      this.forgotPasswordUseCaseProvider, this.registerUseCaseProvider)
      : super(null);

  TextEditingController textInputController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> keyVerify = GlobalKey<FormState>();
  final GlobalKey<FormState> keyResetPassword = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> forgotPassword(BuildContext context) async {
    final body = ForgotPasswordRequest(
      email: textInputController.text,
    );
    if (formKey.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.forgotPassword(body);
        context.pushNamed('verify');
      }, context);
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final body = ForgotPasswordVerifyRequest(
        email: textInputController.text, verifyCode: codeController.text);
    if (keyVerify.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await forgotPasswordUseCaseProvider.forgotPasswordVerify(body);
        context.pushNamed('resetPassword');
        showSnackBar("Xác  thực thành công");
      }, context);
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    if (keyResetPassword.currentState?.validate() == true) {
      if (textInputController.text.isValidEmail) {
        AppUtils.loadingApi(() async {
          await forgotPasswordUseCaseProvider.resetPassword(
              email: textInputController.text,
              password: passwordController.text);
          context.goNamed('login');
          showSnackBar("Cập nhật mật khẩu thành công");
        }, context);
      } else {
        AppUtils.loadingApi(() async {
          await forgotPasswordUseCaseProvider.resetPassword(
              phone: textInputController.text,
              password: passwordController.text);
          context.goNamed('login');
          showSnackBar("Cập nhật mật khẩu thành công");
        }, context);
      }
    }
  }

  Future<void> checkUserPhone(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await registerUseCaseProvider
            .checkUserPhone(textInputController.text)
            .then((val) async {
          await AlertDialogUtil.showAlert(
              context: context,
              title: "Có lỗi xảy ra",
              content: "Số điện thoại không tồn tại trên hệ thống");
        }).catchError((e) async {
          await verifyPhoneNumber(context);
        });
      }, context);
    }
  }

  //0862042810
  // String? verification;
  Future<void> verifyPhoneNumber(BuildContext context) async {
    String phone = "+84${textInputController.text.substring(1)}";
    AppUtils.loadingApi(() async {
      await registerUseCaseProvider.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (firebaseAuthException) {
          AlertDialogUtil.showAlert(
              context: context,
              title: "Có lỗi xảy ra",
              content: firebaseAuthException.message ?? "");
        },
        codeSent: (verificationId, forceResendingToken) {
          // verification = verificationId;
          final verifyOTP = VerifyOTP(
              type: TypeVerify.forgotPasswordPhone,
              phoneNumber: textInputController.text,
              verificationId: verificationId);
          print(">>>>>>>>verificationId: $verificationId");
          context.pushNamed("verify", extra: verifyOTP);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }, context);
  }

  Future<void> signInWithOTP(
      {required String smsCode,
      required String verificationId,
      required BuildContext context}) async {
    AppUtils.loadingApi(() async {
      await registerUseCaseProvider
          .signInWithOTP(smsCode: smsCode, verificationId: verificationId)
          .then((val) async {
        final user = val.user;
        await verifyPhone(
            idToken: await user?.getIdToken() ?? "", uid: user?.uid ?? "");
        context.pushNamed('resetPassword');
      }).catchError((e) {
        AlertDialogUtil.showAlert(
            context: context,
            title: "Lỗi xác thực",
            content: "Mã xác thực không đúng, vui lòng thử lại sau");
      });

      showSnackBar("Xác  thực thành công");
    }, context);
  }

  Future<void> verifyPhone(
      {required String idToken, required String uid}) async {
    await registerUseCaseProvider.postVerifyPhone(
        body: VerifyPhoneRequest(idToken: idToken, uid: uid));
  }
}
