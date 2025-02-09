import 'package:app_tcareer/src/features/authentication/presentation/controllers/forgot_password_controller.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/register_controller.dart';
import 'package:app_tcareer/src/features/authentication/domain/forgot_password_use_case.dart';
import 'package:app_tcareer/src/features/authentication/domain/login_use_case.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/login_controller.dart';
import 'package:app_tcareer/src/features/authentication/domain/register_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginControllerProvider = ChangeNotifierProvider<LoginController>((ref) {
  final loginUseCaseProvider = ref.watch(loginUseCase);
  return LoginController(loginUseCaseProvider, ref);
});

final registerControllerProvider = Provider<RegisterController>((ref) {
  final registerUseCaseProvider = ref.read(registerUseCase);
  final loginController = ref.read(loginControllerProvider);
  return RegisterController(registerUseCaseProvider, loginController);
});

final forgotPasswordControllerProvider =
    Provider<ForgotPasswordController>((ref) {
  final forgotPasswordUseCaseProvider = ref.read(forgotPasswordUseCase);
  final registerUseCaseProvider = ref.read(registerUseCase);
  return ForgotPasswordController(
      forgotPasswordUseCaseProvider, registerUseCaseProvider);
});
