import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/presentation/pages/register/register_page.dart';
import 'package:app_tcareer/src/features/authentication/domain/register_use_case.dart';
import 'package:app_tcareer/src/utils/alert_dialog_util.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login_controller.dart';

class RegisterController extends StateNotifier<void> {
  final RegisterUseCase registerUseCaseProvider;
  final LoginController loginController;
  RegisterController(this.registerUseCaseProvider, this.loginController)
      : super(null);
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyVerifyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyVerifyEmail = GlobalKey<FormState>();

  Future<void> createAccount(
      {required BuildContext context, required RegisterType type}) async {
    AppUtils.loadingApi(() async {
      final body = RegisterRequest(
          name: fullNameController.text,
          phone: phoneController.text,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          password: passController.text);
      await registerUseCaseProvider.register(body);
      if (type != RegisterType.email) {
        await loginController.login(context,
            phone: phoneController.text, password: passController.text);
      } else {
        await sendEmailVerification(context);
      }
    }, context);
  }

  Future<void> onCreate(
      {required BuildContext context, required RegisterType type}) async {
    if (formKey.currentState?.validate() == true) {
      await createAccount(context: context, type: type);
    }
  }

  Future<void> checkUserPhone(BuildContext context) async {
    if (formKeyVerifyPhone.currentState?.validate() == true) {
      AppUtils.loadingApi(() async {
        await registerUseCaseProvider.checkUserPhone(phoneController.text);
        await verifyPhoneNumber(context);
      }, context);
    }
  }

  //0862042810
  // String? verification;
  Future<void> verifyPhoneNumber(BuildContext context) async {
    String phone = "+84${phoneController.text.substring(1)}";
    await registerUseCaseProvider.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (firebaseAuthException) {},
      codeSent: (verificationId, forceResendingToken) {
        // verification = verificationId;
        final verifyOTP = VerifyOTP(
            type: TypeVerify.registerPhone,
            phoneNumber: phoneController.text,
            verificationId: verificationId);
        print(">>>>>>>>verificationId: $verificationId");
        context.pushNamed("verify", extra: verifyOTP);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
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
        context.pushNamed("register", extra: RegisterType.phone);
      }).catchError((e) async {
        await AlertDialogUtil.showAlert(
            context: context,
            title: "Có lỗi xảy ra",
            content: "Xác thực không thành công. Vui lòng thử lại");
      });
    }, context);
  }

  Future<void> verifyPhone(
      {required String idToken, required String uid}) async {
    await registerUseCaseProvider.postVerifyPhone(
        body: VerifyPhoneRequest(idToken: idToken, uid: uid));
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    final body = ForgotPasswordRequest(email: emailController.text);

    AppUtils.loadingApi(() async {
      await registerUseCaseProvider.postSendEmailVerification(body: body);
      final verifyOTP = VerifyOTP(
          type: TypeVerify.registerEmail,
          email: body.email,
          password: passController.text);
      context.pushNamed("verify", extra: verifyOTP);
      // context.pushNamed('verify');
    }, context);
  }

  Future<void> verifyEmail(
      {required BuildContext context,
      required String code,
      required String password,
      required String email}) async {
    final body = ForgotPasswordVerifyRequest(
        email: emailController.text, verifyCode: code);
    // if (formKeyVerifyEmail.currentState?.validate() == true) {
    AppUtils.loadingApi(() async {
      await registerUseCaseProvider.postVerifyEmail(body: body);
      loginController.userNameController.text = body.email ?? "";
      await loginController.login(context, email: email, password: password);
      // context.pushNamed('resetPassword');
      // showSnackBar("Xác  thực thành công");
    }, context);
  }
}
