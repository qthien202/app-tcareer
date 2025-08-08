import 'package:app_tcareer/src/features/authentication/data/models/check_user_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/models/logout_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/verify_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/data/services/auth_service.dart';
import 'package:app_tcareer/src/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;
  AuthRepositoryImpl(this._service);

  @override
  Future<void> checkUserPhone({required CheckUserPhoneRequest req}) async {
    try {
      await _service.postCheckUserPhone(body: req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required ForgotPasswordRequest req}) async {
    try {
      await _service.postForgotPassword(req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPasswordVerify(
      {required ForgotPasswordVerifyRequest req}) async {
    try {
      await _service.postForgotPasswordVerify(body: req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse?> login({required LoginRequest req}) async {
    try {
      final response = await _service.postLogin(req);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponse?> loginWithGoogle(
      {required LoginGoogleRequest req}) async {
    try {
      final response = await _service.postLoginWithGoogle(body: req);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout({required LogoutRequest req}) async {
    try {
      await _service.postLogout(body: req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register({required RegisterRequest req}) async {
    try {
      await _service.postRegister(req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required ResetPasswordRequest req}) async {
    try {
      await _service.postResetPassword(body: req);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyPhoneNumber({required VerifyPhoneRequest req}) async {
    try {
      await _service.postVerifyPhone(body: req);
    } catch (e) {
      rethrow;
    }
  }
}
