import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/data/repositories/connection_respository.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserConnectionUseCase {
  final UserRepository userRepository;
  final ConnectionRepository connectionRepository;
  UserConnectionUseCase(this.userRepository, this.connectionRepository);
  Future<void> postFollow({required String userId, required Users user}) async {
    await connectionRepository.postFollow(userId);
  }

  Users setFollowed(Users user) {
    // Cập nhật thuộc tính `followed` và trả về đối tượng đã được cập nhật
    final currentUser = user.data;
    if (currentUser != null) {
      final updatedUserData =
          currentUser.copyWith(followed: !(currentUser.followed ?? false));
      user = user.copyWith(data: updatedUserData);
    }
    return user;
  }

  Future<void> postAddFriend({required String userId}) async {
    // final updateUser = updatedFriendStatus(user, "send_request");
    await connectionRepository.postAddFriend(userId);
    // return updateUser;
  }

  Future<void> postAcceptFriend({required String userId}) async {
    await connectionRepository.postAcceptFriend(userId);
  }

  Users updatedFriendStatus(Users user, String status) {
    final currentUser = user.data;
    if (currentUser != null) {
      final updatedUserData = currentUser.copyWith(friendStatus: status);
      user = user.copyWith(data: updatedUserData);
    }
    return user;
  }

  Future<void> postDeclineFriend(String userId) async =>
      await connectionRepository.postDeclineFriend(userId);

  Future<void> deleteCancelRequest(String userId) async =>
      await connectionRepository.deleteCancelRequest(userId);
  Future<void> deleteUnFriend(String userId) async =>
      await connectionRepository.deleteUnFriend(userId);
}

final userConnectionUseCaseProvider = Provider((ref) => UserConnectionUseCase(
    ref.watch(userRepositoryProvider),
    ref.watch(connectionRepositoryProvider)));
