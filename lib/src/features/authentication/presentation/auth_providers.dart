import 'package:app_tcareer/src/features/authentication/presentation/controllers/forgot_password_controller.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/register_controller.dart';
import 'package:app_tcareer/src/features/authentication/usecases/forgot_password_use_case.dart';
import 'package:app_tcareer/src/features/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/features/authentication/presentation/controllers/login_controller.dart';
import 'package:app_tcareer/src/features/authentication/usecases/register_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginControllerProvider = ChangeNotifierProvider<LoginController>((ref) {
  final loginUseCaseProvider = ref.watch(loginUseCase);
  return LoginController(loginUseCaseProvider, ref);
});

final registerControllerProvider = Provider<RegisterController>((ref) {
  final registerUseCaseProvider = ref.watch(registerUseCase);
  final loginController = ref.watch(loginControllerProvider);
  return RegisterController(registerUseCaseProvider, loginController);
});

final forgotPasswordControllerProvider =
    Provider<ForgotPasswordController>((ref) {
  final forgotPasswordUseCaseProvider = ref.watch(forgotPasswordUseCase);
  final registerUseCaseProvider = ref.watch(registerUseCase);
  return ForgotPasswordController(
      forgotPasswordUseCaseProvider, registerUseCaseProvider);
});
