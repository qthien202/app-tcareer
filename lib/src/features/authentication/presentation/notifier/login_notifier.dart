import 'package:app_tcareer/src/extensions/auth_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/app_utils.dart';
import '../../domain/auth_provider.dart';
import '../../domain/usecases/auth_usecase.dart';

class LoginNotifier extends AsyncNotifier<void> {
  late final LoginUseCase _loginUseCase;
  late final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _loginWithGoogleUseCase = ref.read(loginWithGoogleUseCaseProvider);
  }

  Future<void> login(BuildContext context,
      {String? phone, String? email, String? password}) async {
    await AppUtils.loadingApi(() async {
      if (userNameController.text.isValidEmail) {
        await _loginUseCase(
          email: email ?? userNameController.text,
          password: password ?? passController.text,
        );
      } else {
        await _loginUseCase(
          phone: phone ?? userNameController.text,
          password: password ?? passController.text,
        );
      }
    }, context);
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await login(context);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await AppUtils.loadingApi(() async {
      await _loginWithGoogleUseCase();
    }, context);
  }
}

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, void>(() {
  return LoginNotifier();
});
