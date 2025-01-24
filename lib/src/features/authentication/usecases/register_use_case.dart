import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<void> register(RegisterRequest body) async {
    return await authRepository.register(body);
  }

  Future<void> checkUserPhone(String phone) async =>
      await authRepository.postCheckUserPhone(phone);

  Future<void> verifyPhoneNumber(
          {required String phoneNumber,
          required void Function(PhoneAuthCredential phoneAuthCredential)
              verificationCompleted,
          required void Function(FirebaseAuthException firebaseAuthException)
              verificationFailed,
          required void Function(
                  String verificationId, int? forceResendingToken)
              codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout}) async =>
      await authRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

  Future<UserCredential> signInWithOTP(
          {required String smsCode, required String verificationId}) async =>
      await authRepository.signInWithOTP(
          smsCode: smsCode, verificationId: verificationId);

  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async =>
      await authRepository.sendVerificationCode(phoneNumber);
  Future<TwilioResponse> verifyCode(
          {required String phoneNumber, required String code}) async =>
      await authRepository.verifyCode(phoneNumber: phoneNumber, code: code);

  Future<void> postVerifyPhone({required VerifyPhoneRequest body}) async =>
      await authRepository.postVerifyPhone(body: body);

  Future<void> postSendEmailVerification(
          {required ForgotPasswordRequest body}) async =>
      await authRepository.forgotPassword(body);
  Future<void> postVerifyEmail(
          {required ForgotPasswordVerifyRequest body}) async =>
      await authRepository.forgotPasswordVerify(body);
}

final registerUseCase =
    Provider((ref) => RegisterUseCase(ref.watch(authRepository)));
