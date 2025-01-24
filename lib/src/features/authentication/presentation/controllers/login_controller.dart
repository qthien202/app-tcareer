import 'package:app_tcareer/firebase_options.dart';
import 'package:app_tcareer/src/extensions/auth_extension.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_request.dart';
import 'package:app_tcareer/src/features/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginController extends ChangeNotifier {
  final LoginUseCase loginUseCaseProvider;
  final Ref ref;
  LoginController(this.loginUseCaseProvider, this.ref);
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> login(BuildContext context,
      {String? phone, String? email, String? password}) async {
    AppUtils.loadingApi(() async {
      if (userNameController.text.isValidEmail) {
        await loginUseCaseProvider.login(
            email: email ?? userNameController.text,
            password: password ?? passController.text);
      } else {
        await loginUseCaseProvider.login(
            phone: phone ?? userNameController.text,
            password: password ?? passController.text);
      }
    }, context);
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      await login(context);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final jobRepository = ref.watch(jobRepositoryProvider);
    AppUtils.loadingApi(() async {
      await loginUseCaseProvider.loginWithGoogle();
    }, context);

    // context.goNamed("home");
  }
}
