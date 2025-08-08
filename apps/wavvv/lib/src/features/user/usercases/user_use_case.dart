import 'package:authentication/authentication.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/change_password_request.dart';


class UserUseCase {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  final FirebaseAuthRepository firebaseAuthRepository;
  UserUseCase(
      this.userRepository, this.authRepository, this.firebaseAuthRepository);

  Future<Users> getUserInfo() async => await userRepository.getUserInfo();
  Future<Users> getUserById(String userId) async =>
      await userRepository.getUserById(userId);
  Future getFollowers(String userId) async =>
      await userRepository.getFollower(userId);

  Future getFriends(String userId) async =>
      await userRepository.getFriends(userId);

  Future<void> putUpdateProfile({required UpdateProfileRequest body}) async =>
      await userRepository.putUpdateProfile(body: body);

  Future<void> postCreateResume({required CreateResumeRequest body}) async =>
      await userRepository.postCreateResume(body: body);

  Future<ResumeModel> getResume({String? userId}) async =>
      await userRepository.getResume(userId: userId);

  Future<void> verifyPhoneNumber(
          {required String phoneNumber,
          required void Function(PhoneAuthCredential phoneAuthCredential)
              verificationCompleted,
          required void Function(FirebaseAuthException firebaseAuthException)
              verificationFailed,
          required void Function(
                  String verificationId, int? forceResendingToken)
              codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout}) async =>
      await firebaseAuthRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  // Future<UserCredential> signInWithOTP(
  //         {required String smsCode, required String verificationId}) async =>
  //     await firebaseAuthRepository.(
  //         smsCode: smsCode, verificationId: verificationId);

  Future<void> putChangPassword({required ChangePasswordRequest body}) async =>
      await userRepository.putChangePassword(body: body);
}

final userUseCaseProvider = Provider((ref) => UserUseCase(
    ref.read(userRepositoryProvider),
    ref.read(authRepositoryProvider),
    ref.watch(firebaseAuthRepositoryProvider)));
