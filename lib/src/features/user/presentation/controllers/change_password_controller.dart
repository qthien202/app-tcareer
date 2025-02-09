import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:app_tcareer/src/features/user/data/models/change_password_request.dart';
import 'package:app_tcareer/src/features/user/domain/user_use_case.dart';
import 'package:app_tcareer/src/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordController extends ChangeNotifier {
  final UserUseCase userUseCase;
  ChangePasswordController(this.userUseCase);
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Future<void> verifyPhoneNumber(BuildContext context) async {
    String phone = "+84${phoneController.text.substring(1)}";
    AppUtils.loadingApi(() async {
      await userUseCase.verifyPhoneNumber(
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
              phoneNumber: phoneController.text,
              verificationId: verificationId);
          print(">>>>>>>>verificationId: $verificationId");
          context.pushNamed("userVerification", extra: verifyOTP);
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
      await userUseCase
          .signInWithOTP(smsCode: smsCode, verificationId: verificationId)
          .then((val) async {
        print(">>>>>>>>>>idToken: ${await val.user?.getIdToken()}");
      }).catchError((e) async {
        await AlertDialogUtil.showAlert(
            context: context,
            title: "Có lỗi xảy ra",
            content:
                "Mã xác minh từ SMS/TOTP không hợp lệ. Vui lòng kiểm tra và nhập lại mã xác minh chính xác");
      });
    }, context);
  }

  Future<void> changePassword(BuildContext context) async {
    AppUtils.loadingApi(() async {
      final body = ChangePasswordRequest(
          password: currentPasswordController.text,
          newPassword: passwordController.text,
          passwordNewConfirmation: confirmPasswordController.text);
      await userUseCase.putChangPassword(body: body);
      showSnackBar("Đổi mật khẩu thành công");
      context.goNamed("accountSetting");
    }, context);
  }

  GlobalKey<FormState> formVerifyKey = GlobalKey<FormState>();
}

final changePasswordControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.read(userUseCaseProvider);

  return ChangePasswordController(userUseCase);
});
