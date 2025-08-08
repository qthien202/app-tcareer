import 'package:authentication/src/data/models/login_google_request.dart';
import 'package:authentication/src/data/models/login_request.dart';
import 'package:authentication/src/data/models/login_response.dart';
import 'package:authentication/src/data/models/logout_request.dart';
import 'package:authentication/src/data/models/register_request.dart';

import '../../data/models/check_user_phone_request.dart';
import '../../data/models/forgot_password_request.dart';
import '../../data/models/forgot_password_verify_request.dart';
import '../../data/models/reset_password_request.dart';
import '../../data/models/verify_phone_request.dart';

abstract class AuthRepository {
  Future<void> register({required RegisterRequest req});
  Future<LoginResponse?> login({required LoginRequest req});
  Future<LoginResponse?> loginWithGoogle({required LoginGoogleRequest req});
  Future<void> logout({required LogoutRequest req});
  Future<void> forgotPassword({required ForgotPasswordRequest req});
  Future<void> forgotPasswordVerify({required ForgotPasswordVerifyRequest req});
  Future<void> resetPassword({required ResetPasswordRequest req});
  Future<void> checkUserPhone({required CheckUserPhoneRequest req});
  Future<void> verifyPhoneNumber({required VerifyPhoneRequest req});
}
