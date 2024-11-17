import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_otp.dart';
import 'package:app_tcareer/src/features/authentication/usecases/register_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyVerifyPhone = GlobalKey<FormState>();

  Future<void> createAccount(BuildContext context) async {
    AppUtils.loadingApi(() async {
      final body = RegisterRequest(
          name: fullNameController.text,
          phone: phoneController.text,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          password: passController.text);
      await registerUseCaseProvider.register(body);
      await loginController.login(context,
          phone: phoneController.text, password: passController.text);
    }, context);
  }

  Future<void> onCreate(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await createAccount(context);
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
            phoneController.text, verificationId, TypeVerify.register);
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
      await registerUseCaseProvider.signInWithOTP(
          smsCode: smsCode, verificationId: verificationId);
      context.pushNamed("register");
    }, context);
  }

  Future<void> sendVerificationCode() async {
    String phone = "+84${phoneController.text.substring(1)}";
    final response = await registerUseCaseProvider.sendVerificationCode(phone);
    print(">>>>>>>response: $response");
  }
}
