import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:app_tcareer/src/features/jobs/data/models/add_job_topic_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/topic_job_favorite_response.dart';
import 'package:app_tcareer/src/features/user/data/models/change_password_request.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUseCase {
  final UserRepository userRepository;
  final IAuthRepository authRepository;
  UserUseCase(this.userRepository, this.authRepository);

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

  Future<GetJobResponse> getPostedJob({int? page, num? userId}) async =>
      await userRepository.getPostedJob(page: page, userId: userId);

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
      await authRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  Future<UserCredential> signInWithOTP(
          {required String smsCode, required String verificationId}) async =>
      await authRepository.signInWithOTP(
          smsCode: smsCode, verificationId: verificationId);

  Future<void> putChangPassword({required ChangePasswordRequest body}) async =>
      await userRepository.putChangPassword(body: body);

  Future<void> postAddJobTopic({required AddJobTopicRequest body}) async =>
      await userRepository.postAddJobTopic(body: body);
  Future<TopicJobFavoriteResponse> getJobTopicFavorite() async =>
      await userRepository.getTopicJobFavorite();
  Future<List<JobTopicModel>> getJobTopic() async =>
      await userRepository.getJobTopic();
}

final userUseCaseProvider = Provider((ref) =>
    UserUseCase(ref.read(userRepositoryProvider), ref.read(authRepository)));
