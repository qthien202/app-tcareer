import 'package:authentication/src/data/repositories/firebase_auth_repository_impl.dart';
import 'package:authentication/src/domain/repositories/firebase_auth_repository.dart';
import 'package:authentication/src/domain/usecases/login/logout_usecase.dart';
import 'package:authentication/src/utils/user_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common/core/api/client.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/services/auth_service.dart';
import 'repositories/auth_repository.dart';
import 'usecases/auth_usecase.dart';

/// Services
final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
});

// Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  return FirebaseAuthRepositoryImpl(firebaseAuth, googleSignIn);
});

/// UseCases

final forgotPasswordVerifyUseCaseProvider =
    Provider<ForgotPasswordVerifyUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ForgotPasswordVerifyUseCase(repo);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repo);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(repo);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final util = ref.watch(userUtilsProvider);
  return LoginUseCase(repo, util, ref);
});

final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogleUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final firebaseAuthRepo = ref.watch(firebaseAuthRepositoryProvider);
  final util = ref.watch(userUtilsProvider);
  return LoginWithGoogleUseCase(firebaseAuthRepo, authRepo, util, ref);
});

final loginWithOTPUseCaseProvider = Provider<LoginWithOtpUseCase>((ref) {
  final repo = ref.watch(firebaseAuthRepositoryProvider);
  return LoginWithOtpUseCase(repo);
});
final checkUserPhoneUseCaseProvider = Provider<CheckUserPhoneUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return CheckUserPhoneUseCase(repo);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repo);
});

final verifyPhoneNumberOTPProvider = Provider<VerifyPhoneNumberUseCase>((ref) {
  final repo = ref.watch(firebaseAuthRepositoryProvider);
  return VerifyPhoneNumberUseCase(repo);
});

final verifyPhoneNumberProvider = Provider<VerifyPhoneUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return VerifyPhoneUseCase(repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final firebaseRepo = ref.watch(firebaseAuthRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(firebaseRepo, authRepo);
});
