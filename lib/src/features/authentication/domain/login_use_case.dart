import 'package:app_tcareer/src/features/authentication/data/models/login_google_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUseCase {
  final IAuthRepository authRepository;
  LoginUseCase(this.authRepository);

  Future<void> login(
      {String? phone, String? email, required String password}) async {
    return await authRepository.login(
        phone: phone, email: email, password: password);
  }

  Future<void> logout() async => await authRepository.logout();

  Future loginWithGoogle() async {
    return await authRepository.loginWithGoogle();
  }
}

final loginUseCase = Provider((ref) => LoginUseCase(ref.watch(authRepository)));
