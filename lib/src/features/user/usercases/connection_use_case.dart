import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionUseCase {
  final UserRepository userRepository;
  final Ref ref;
  ConnectionUseCase(this.userRepository, this.ref);

  Future<void> monitorConnection() async {
    final userUtils = ref.watch(userUtilsProvider);
    if (await userUtils.isAuthenticated()) {
      userRepository.monitorConnection(
        (event) {
          final connected = event.snapshot.value as bool;
          print(">>>>>>>>>connected: $connected");
          if (connected) {
            setUserOnlineStatus();
          } else {
            setUserOfflineStatus();
          }
        },
      );
    }
  }

  Future<void> setUserOnlineStatus() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "status": "online",
      "inMessage": false,
      "updatedAt": DateTime.now().toIso8601String(),
    };
    userRepository
        .addData(path: "users/$userId", data: data, dataUpdateDisconnect: {
      "inMessage": false,
      "status": "offline",
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  Future<void> setUserOnlineStatusInMessage() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "status": "online",
      "inMessage": true,
      "updatedAt": DateTime.now().toIso8601String(),
    };
    if (userId != "") {
      userRepository
          .addData(path: "users/$userId", data: data, dataUpdateDisconnect: {
        "inMessage": false,
        "status": "offline",
        "updatedAt": DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> setUserOfflineStatus() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "inMessage": false,
      "status": "offline",
      "updatedAt": DateTime.now().toIso8601String(),
    };
    userRepository.addData(path: "users/$userId", data: data);
  }

  Future<void> setUserOfflineStatusInBackground() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    Map<String, dynamic> data = {
      "inMessage": false,
      "status": "online",
      "updatedAt": DateTime.now().toIso8601String(),
    };
    if (userId != "") {
      userRepository.addData(path: "users/$userId", data: data);
      await Future.delayed(const Duration(minutes: 1));
      Map<String, dynamic> updatedData = {
        "inMessage": false,
        "status": "offline",
        "updatedAt": DateTime.now().toIso8601String(),
      };
      userRepository.addData(path: "users/$userId", data: updatedData);
    }
    // await setUserOfflineStatus();
  }

  Future<bool> getInMessage() async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    final data = await userRepository.getData("users/$userId");
    print(">>>>>>>>>>>>dataMessage: $data");
    bool inMessage = data?['inMessage'] as bool;
    return inMessage;
  }
}

final connectionUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return ConnectionUseCase(userRepository, ref);
});
