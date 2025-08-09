import 'package:authentication/src/data/models/check_user_phone_request.dart';
import 'package:authentication/src/data/models/forgot_password_request.dart';
import 'package:authentication/src/data/models/forgot_password_verify_request.dart';
import 'package:authentication/src/data/models/register_request.dart';
import 'package:authentication/src/data/models/verify_otp.dart';
import 'package:authentication/src/data/models/verify_phone_request.dart';
import 'package:authentication/src/domain/usecases/auth_usecase.dart';
import 'package:authentication/src/presentation/notifiers/login_notifier.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/auth_provider.dart';
import '../pages/register/register_page.dart';

class RegisterNotifier extends AsyncNotifier<void> {
  late final RegisterUseCase _registerUseCase;
  late final LoginNotifier _loginNotifier;
  late final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;
  late final VerifyPhoneUseCase _verifyPhoneUseCase;
  late final CheckUserPhoneUseCase _checkUserPhoneUseCase;
  late final LoginWithOtpUseCase _loginWithOtpUseCase;
  late final ForgotPasswordVerifyUseCase _forgotPasswordVerifyUseCase;
  late final ForgotPasswordUseCase _forgotPasswordUseCase;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKeyVerifyPhone = GlobalKey<FormState>();
  final formKeyVerifyEmail = GlobalKey<FormState>();

  @override
  void build() {
    _registerUseCase = ref.read(registerUseCaseProvider);
    _loginNotifier = ref.read(loginNotifierProvider.notifier);
    _checkUserPhoneUseCase = ref.read(checkUserPhoneUseCaseProvider);
    _verifyPhoneNumberUseCase = ref.read(verifyPhoneNumberOTPProvider);
    _loginWithOtpUseCase = ref.read(loginWithOTPUseCaseProvider);
    _verifyPhoneUseCase = ref.read(verifyPhoneNumberProvider);
    _forgotPasswordVerifyUseCase =
        ref.read(forgotPasswordVerifyUseCaseProvider);
    _forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
  }

  Future<void> createAccount({
    required BuildContext context,
    required RegisterType type,
  }) async {
    final body = RegisterRequest(
      name: fullNameController.text,
      phone: phoneController.text,
      email: emailController.text.isNotEmpty ? emailController.text : null,
      password: passController.text,
    );

    await AppUtils.loadingApi(() async {
      await _registerUseCase(body);

      if (type != RegisterType.email) {
        await _loginNotifier.login(
          context,
          phone: phoneController.text,
          password: passController.text,
        );
      } else {
        await sendEmailVerification(context);
      }
    }, context);
  }

  Future<void> onCreate({
    required BuildContext context,
    required RegisterType type,
  }) async {
    if (formKey.currentState?.validate() == true) {
      await createAccount(context: context, type: type);
    }
  }

  Future<void> checkUserPhone(BuildContext context) async {
    if (formKeyVerifyPhone.currentState?.validate() == true) {
      await AppUtils.loadingApi(() async {
        await _checkUserPhoneUseCase(
            CheckUserPhoneRequest(phone: phoneController.text));
        await verifyPhoneNumber(context);
      }, context);
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    final phone = "+84${phoneController.text.substring(1)}";

    await _verifyPhoneNumberUseCase(
      phoneNumber: phone,
      verificationCompleted: (_) {},
      verificationFailed: (error) {
        AlertDialogUtil.showAlert(
          context: context,
          title: "Có lỗi xảy ra",
          content: error.message ?? "",
        );
      },
      codeSent: (verificationId, _) {
        final verifyOTP = VerifyOTP(
          type: TypeVerify.registerPhone,
          phoneNumber: phoneController.text,
          verificationId: verificationId,
        );

        context.pushNamed("verify", extra: verifyOTP);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> signInWithOTP({
    required String smsCode,
    required String verificationId,
    required BuildContext context,
  }) async {
    await AppUtils.loadingApi(() async {
      final userCredential = await _loginWithOtpUseCase(
        smsCode: smsCode,
        verificationId: verificationId,
      );

      final user = userCredential?.user;
      await verifyPhone(
        idToken: await user?.getIdToken() ?? "",
        uid: user?.uid ?? "",
      );

      context.pushNamed("register", extra: RegisterType.phone);
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

  Future<void> sendEmailVerification(BuildContext context) async {
    final body = ForgotPasswordRequest(email: emailController.text);

    await AppUtils.loadingApi(() async {
      await _forgotPasswordUseCase(body);
      final verifyOTP = VerifyOTP(
        type: TypeVerify.registerEmail,
        email: body.email,
        password: passController.text,
      );

      context.pushNamed("verify", extra: verifyOTP);
    }, context);
  }

  Future<void> verifyEmail({
    required BuildContext context,
    required String code,
    required String password,
    required String email,
  }) async {
    final body = ForgotPasswordVerifyRequest(
      email: email,
      verifyCode: code,
    );

    await AppUtils.loadingApi(() async {
      await _forgotPasswordVerifyUseCase(body);
      _loginNotifier.userNameController.text = email;

      await _loginNotifier.login(
        context,
        email: email,
        password: password,
      );
    }, context);
  }
}

final registerNotifierProvider =
    AsyncNotifierProvider<RegisterNotifier, void>(() => RegisterNotifier());
