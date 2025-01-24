import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/features/authentication/data/models/check_user_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/logout_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_phone_request.dart';
import 'package:app_tcareer/src/services/twilio/twilio_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../../../../services/services.dart';

class AuthRepository {
  final Ref ref;
  AuthRepository(this.ref);

  Future<void> register(RegisterRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postRegister(body: body);
  }

  Future<void> login(
      {String? phone, String? email, required String password}) async {
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final userUtil = ref.watch(userUtilsProvider);
      String deviceToken = await userUtil.getDeviceToken() ?? "";
      String deviceId = await userUtil.getDeviceId() ?? "";
      final body = LoginRequest(
          phone: phone,
          email: email,
          password: password,
          deviceToken: deviceToken,
          deviceId: deviceId);
      final response = await apiServices.postLogin(body: body);
      Map<String, dynamic> payload =
          JwtDecoder.decode(response.accessToken ?? "");
      print(">>>>>>>>payload: $payload");
      userUtil.saveAuthToken(
          authToken: response.accessToken ?? "",
          refreshToken: response.refreshToken ?? "",
          userId: payload['sub']);
      var providers = ref.container.getAllProviderElements();
      for (var element in providers) {
        element.invalidateSelf();
      }

      // ref.read(isAuthenticatedProvider.notifier).update((state) => true);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    final user = await fireBaseAuth.signInWithGoogle();
    final accessToken = user?.credential?.accessToken;
    final userUtil = ref.watch(userUtilsProvider);
    String deviceToken = await userUtil.getDeviceToken() ?? "";
    String deviceId = await userUtil.getDeviceId() ?? "";
    try {
      final apiServices = ref.watch(apiServiceProvider);
      final response = await apiServices.postLoginWithGoogle(
          body: LoginGoogleRequest(
              accessToken: accessToken,
              deviceId: deviceId,
              deviceToken: deviceToken));

      Map<String, dynamic> payload =
          JwtDecoder.decode(response.accessToken ?? "");
      print(">>>>>>>>payload: $payload");
      print(">>>>>>>>>userId: ${payload['sub']}");
      userUtil.saveAuthToken(
          authToken: response.accessToken ?? "",
          refreshToken: response.refreshToken ?? "",
          userId: payload['sub']);
      var providers = ref.container.getAllProviderElements();
      for (var element in providers) {
        element.invalidateSelf();
      }
      print(">>>>>>>>>>>>userId2: ${await userUtil.getUserId()}");
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    final userUtil = ref.watch(userUtilsProvider);

    final apiServices = ref.watch(apiServiceProvider);
    String refreshToken = await userUtil.getRefreshToken();
    await apiServices.postLogout(
        body: LogoutRequest(refreshToken: refreshToken));
    await fireBaseAuth.signOut();
    await userUtil.clearCache();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.deleteToken();
    String? deviceToken = await firebaseMessaging.getToken();
    await userUtil.saveDeviceToken(deviceToken: deviceToken ?? "");
    await DefaultCacheManager().emptyCache();
  }

  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPassword(body: body);
  }

  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postForgotPasswordVerify(body: body);
  }

  Future<void> resetPassword({
    String? email,
    String? phone,
    required String password,
  }) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postResetPassword(
        body: ResetPasswordRequest(
            email: email,
            phone: phone,
            password: password,
            key: Env.resetPasswordKey));
  }

  Future<void> postCheckUserPhone(String phone) async {
    final apiServices = ref.watch(apiServiceProvider);
    await apiServices.postCheckUserPhone(
        body: CheckUserPhoneRequest(phone: phone));
  }

  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential phoneAuthCredential)
          verificationCompleted,
      required void Function(FirebaseAuthException firebaseAuthException)
          verificationFailed,
      required void Function(String verificationId, int? forceResendingToken)
          codeSent,
      required void Function(String verificationId)
          codeAutoRetrievalTimeout}) async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    return await fireBaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<UserCredential> signInWithOTP(
      {required String smsCode, required String verificationId}) async {
    final fireBaseAuth = ref.watch(firebaseAuthServiceProvider);
    return await fireBaseAuth.signInWithOTP(
        smsCode: smsCode, verificationId: verificationId);
  }

  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async {
    final twilio = ref.watch(twilioService);
    return await twilio.sendVerificationCode(phoneNumber);
  }

  Future<TwilioResponse> verifyCode(
      {required String phoneNumber, required String code}) async {
    final twilio = ref.watch(twilioService);
    return await twilio.verifyCode(phoneNumber: phoneNumber, code: code);
  }

  Future<void> postVerifyPhone({required VerifyPhoneRequest body}) async {
    final api = ref.read(apiServiceProvider);
    return await api.postVerifyPhone(body: body);
  }
}

final authRepository = Provider((ref) => AuthRepository(ref));
