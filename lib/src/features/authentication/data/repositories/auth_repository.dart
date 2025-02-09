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
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../../../../services/services.dart';

abstract class IAuthRepository {
  Future<void> register(RegisterRequest body);
  Future<void> login({String? phone, String? email, required String password});
  Future<void> loginWithGoogle();
  Future<void> logout();
  Future<void> forgotPassword(ForgotPasswordRequest body);
  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body);
  Future<void> resetPassword(
      {String? email, String? phone, required String password});
  Future<void> postCheckUserPhone(String phone);
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential phoneAuthCredential)
        verificationCompleted,
    required void Function(FirebaseAuthException firebaseAuthException)
        verificationFailed,
    required void Function(String verificationId, int? forceResendingToken)
        codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  });
  Future<UserCredential> signInWithOTP(
      {required String smsCode, required String verificationId});
  Future<TwilioResponse> sendVerificationCode(String phoneNumber);
  Future<TwilioResponse> verifyCode(
      {required String phoneNumber, required String code});
  Future<void> postVerifyPhone({required VerifyPhoneRequest body});
}

class AuthRepository implements IAuthRepository {
  final ApiServices _apiServices;
  final FirebaseAuthService _firebaseAuth;
  final UserUtils _userUtils;
  final TwilioService _twilioService;

  AuthRepository({
    required ApiServices apiServices,
    required FirebaseAuthService firebaseAuth,
    required UserUtils userUtils,
    required TwilioService twilioService,
  })  : _apiServices = apiServices,
        _firebaseAuth = firebaseAuth,
        _userUtils = userUtils,
        _twilioService = twilioService;

  @override
  Future<void> register(RegisterRequest body) async {
    await _apiServices.postRegister(body: body);
  }

  @override
  Future<void> login(
      {String? phone, String? email, required String password}) async {
    String deviceToken = await _userUtils.getDeviceToken() ?? "";
    String deviceId = await _userUtils.getDeviceId() ?? "";
    final body = LoginRequest(
      phone: phone,
      email: email,
      password: password,
      deviceToken: deviceToken,
      deviceId: deviceId,
    );
    final response = await _apiServices.postLogin(body: body);
    Map<String, dynamic> payload =
        JwtDecoder.decode(response.accessToken ?? "");
    _userUtils.saveAuthToken(
      authToken: response.accessToken ?? "",
      refreshToken: response.refreshToken ?? "",
      userId: payload['sub'],
    );
  }

  @override
  Future<void> loginWithGoogle() async {
    final user = await _firebaseAuth.signInWithGoogle();
    final accessToken = user?.credential?.accessToken;
    String deviceToken = await _userUtils.getDeviceToken() ?? "";
    String deviceId = await _userUtils.getDeviceId() ?? "";
    final response = await _apiServices.postLoginWithGoogle(
      body: LoginGoogleRequest(
        accessToken: accessToken,
        deviceId: deviceId,
        deviceToken: deviceToken,
      ),
    );
    Map<String, dynamic> payload =
        JwtDecoder.decode(response.accessToken ?? "");
    _userUtils.saveAuthToken(
      authToken: response.accessToken ?? "",
      refreshToken: response.refreshToken ?? "",
      userId: payload['sub'],
    );
  }

  @override
  Future<void> logout() async {
    String refreshToken = await _userUtils.getRefreshToken();
    await _apiServices.postLogout(
        body: LogoutRequest(refreshToken: refreshToken));
    await _firebaseAuth.signOut();
    await _userUtils.clearCache();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.deleteToken();
    String? deviceToken = await firebaseMessaging.getToken();
    await _userUtils.saveDeviceToken(deviceToken: deviceToken ?? "");
    await DefaultCacheManager().emptyCache();
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    await _apiServices.postForgotPassword(body: body);
  }

  @override
  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    await _apiServices.postForgotPasswordVerify(body: body);
  }

  @override
  Future<void> resetPassword(
      {String? email, String? phone, required String password}) async {
    await _apiServices.postResetPassword(
      body: ResetPasswordRequest(
        email: email,
        phone: phone,
        password: password,
        key: Env.resetPasswordKey,
      ),
    );
  }

  @override
  Future<void> postCheckUserPhone(String phone) async {
    await _apiServices.postCheckUserPhone(
        body: CheckUserPhoneRequest(phone: phone));
  }

  @override
  Future<void> postVerifyPhone({required VerifyPhoneRequest body}) async {
    await _apiServices.postVerifyPhone(body: body);
  }

  @override
  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async =>
      await _twilioService.sendVerificationCode(phoneNumber);

  @override
  Future<UserCredential> signInWithOTP(
          {required String smsCode, required String verificationId}) async =>
      await _firebaseAuth.signInWithOTP(
          smsCode: smsCode, verificationId: verificationId);

  @override
  Future<TwilioResponse> verifyCode(
          {required String phoneNumber, required String code}) async =>
      await _twilioService.verifyCode(phoneNumber: phoneNumber, code: code);

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential phoneAuthCredential)
        verificationCompleted,
    required void Function(FirebaseAuthException firebaseAuthException)
        verificationFailed,
    required void Function(String verificationId, int? forceResendingToken)
        codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) async =>
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
}

final authRepository = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    apiServices: ref.read(apiServiceProvider),
    firebaseAuth: ref.read(firebaseAuthServiceProvider),
    userUtils: ref.read(userUtilsProvider),
    twilioService: ref.read(twilioService),
  );
});
