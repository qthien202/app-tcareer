import 'package:authentication/authentication.dart' as auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const auth.LoginPage();
  }
}

class RegisterPage extends StatelessWidget {
  final auth.RegisterType type;
  const RegisterPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return auth.RegisterPage(type: type);
  }
}

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const auth.VerifyEmailPage();
  }
}

class VerifyPhonePage extends StatelessWidget {
  const VerifyPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const auth.VerifyPhonePage();
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return auth.ForgotPasswordPage(
      onVerifyEmailSuccess: () => context.pushNamed('verify'),
      onVerifyPhoneSuccess: (data) => context.pushNamed("verify", extra: data),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const auth.ResetPasswordPage();
  }
}

class VerifyPage extends StatelessWidget {
  final auth.VerifyOTP? verifyOTP;

  const VerifyPage({super.key, this.verifyOTP});

  @override
  Widget build(BuildContext context) {
    return auth.VerifyPage(verifyOTP: verifyOTP);
  }
}
