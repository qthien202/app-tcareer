import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionRepository {
  final Ref ref;
  ConnectionRepository(this.ref);

  Future<void> postFollow(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postFollow(userId: userId);
  }

  Future<void> postAddFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postAddFriend(userId: userId);
  }

  Future<void> postAcceptFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postAcceptFriend(userId: userId);
  }

  Future<void> postDeclineFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postDeclineFriend(userId: userId);
  }

  Future<void> deleteCancelRequest(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.deleteCancelRequest(userId: userId);
  }

  Future<void> deleteUnFriend(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.deleteUnFriend(userId: userId);
  }
}

final connectionRepositoryProvider =
    Provider((ref) => ConnectionRepository(ref));
