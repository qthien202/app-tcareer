import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import '../../../../core/core.dart';
import '../models/check_user_phone_request.dart';
import '../models/forgot_password_verify_request.dart';
import '../models/login_google_request.dart';
import '../models/login_request.dart';
import '../models/logout_request.dart';
import '../models/refresh_token_request.dart';
import '../models/register_request.dart';
import '../models/login_response.dart';
import '../models/forgot_password_request.dart';
import '../models/reset_password_request.dart';
import '../models/verify_phone_request.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('auth/login')
  Future<LoginResponse> postLogin(@Body() LoginRequest body);

  @POST('auth/register')
  Future<void> postRegister(@Body() RegisterRequest body);

  @POST('auth/forgot_password')
  Future<void> postForgotPassword(@Body() ForgotPasswordRequest body);
  @POST('auth/login_google')
  Future<LoginResponse> postLoginWithGoogle(
      {@Body() required LoginGoogleRequest body});
  @POST("auth/refresh")
  Future<LoginResponse> postRefreshToken(
      {@Body() required RefreshTokenRequest body});

  @POST('auth/forgot_password_verify')
  Future postForgotPasswordVerify(
      {@Body() required ForgotPasswordVerifyRequest body});

  @POST('auth/forgot_password_change')
  Future postResetPassword({@Body() required ResetPasswordRequest body});

  @POST('auth/logout')
  Future postLogout({@Body() required LogoutRequest body});

  @POST('auth/user/phone')
  Future postCheckUserPhone({@Body() required CheckUserPhoneRequest body});
  @POST('auth/verify_phone')
  Future postVerifyPhone({@Body() required VerifyPhoneRequest body});
}
