import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUseCase {
  final UserRepository userRepository;
  UserUseCase(this.userRepository);

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
}

final userUseCaseProvider =
    Provider((ref) => UserUseCase(ref.watch(userRepositoryProvider)));
