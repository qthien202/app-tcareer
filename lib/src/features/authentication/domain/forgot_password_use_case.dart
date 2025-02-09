import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/reset_password_request.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordUseCase {
  final IAuthRepository authRepository;
  ForgotPasswordUseCase(this.authRepository);

  Future<void> forgotPassword(ForgotPasswordRequest body) async {
    return await authRepository.forgotPassword(body);
  }

  Future<void> forgotPasswordVerify(ForgotPasswordVerifyRequest body) async {
    return await authRepository.forgotPasswordVerify(body);
  }

  Future<void> resetPassword(
      {String? email, String? phone, required String password}) async {
    return await authRepository.resetPassword(
        phone: phone, email: email, password: password);
  }
}

final forgotPasswordUseCase =
    Provider((ref) => ForgotPasswordUseCase(ref.watch(authRepository)));
