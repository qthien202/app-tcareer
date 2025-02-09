import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/user_friend_page.dart';
import 'package:app_tcareer/src/features/user/presentation/pages/user_list_page.dart';
import 'package:app_tcareer/src/features/user/domain/user_connection_use_case.dart';
import 'package:app_tcareer/src/features/user/domain/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserConnectionController extends ChangeNotifier {
  final UserConnectionUseCase connectionUseCase;
  final AnotherUserController anotherUserController;
  final UserUseCase userUseCase;
  final String userId;
  final Ref ref;
  UserConnectionController(this.connectionUseCase, this.ref, this.userUseCase,
      this.anotherUserController, this.userId) {}

  Future<void> postFollow(BuildContext context) async {
    // Đọc `AnotherUserController` từ provider

    // Lấy đối tượng `anotherUserData` và `currentFollowed`
    final currentUser = anotherUserController.anotherUserData;

    await connectionUseCase.postFollow(userId: userId, user: currentUser!);
    await anotherUserController.getUserById(userId);
    if (currentUser.data?.followed != true) {
      showSnackBar("Bạn đã theo dõi ${currentUser.data?.fullName}");
    }
  }

  Future<void> postAddFriend(BuildContext context) async {
    // final currentUser = anotherUserController.anotherUserData;
    // if (currentUser?.data?.friendStatus != "sent_request") {
    //
    // }

    AppUtils.futureApi(() async {
      await connectionUseCase.postAddFriend(userId: userId).then((val) async {
        await anotherUserController.getUserById(userId);

        showSnackBar(
            "Đã gửi lời mời kết bạn đến ${anotherUserController.anotherUserData?.data?.fullName}");
      }).catchError((e) async {
        await anotherUserController.getUserById(userId);
      });
    }, context, (val) {});
  }

  Future<void> postAcceptFriend(BuildContext context) async {
    await connectionUseCase
        .postAcceptFriend(
      userId: userId,
    )
        .then((val) async {
      await anotherUserController.getUserById(userId);
      context.pop();
      showSnackBar(
          "Bạn đã đồng ý kết bạn với ${anotherUserController.anotherUserData?.data?.fullName}");
    }).catchError((e) async {
      context.pop();
      await anotherUserController.getUserById(userId);
    });
  }

  Future<void> postDeclineFriend(BuildContext context) async {
    final currentUser = anotherUserController.anotherUserData;
    await connectionUseCase
        .postDeclineFriend(
      userId,
    )
        .then((val) async {
      await anotherUserController.getUserById(userId);
      context.pop();
      showSnackBar("Đã từ chối kết bạn với ${currentUser?.data?.fullName}");
    }).catchError((e) async {
      await anotherUserController.getUserById(userId);
      context.pop();
    });
  }

  Future<void> showModalDeleteFriend({required BuildContext context}) async {
    final currentUser = anotherUserController.anotherUserData?.data;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(currentUser?.avatar ??
                    "https://ui-avatars.com/api/?name=${currentUser?.fullName}&background=random"),
              ),
            ],
          ),
          message: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Hủy kết bạn với ${currentUser?.fullName}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async => await unFriend(context),
                child: const Text(
                  'Hủy kết bạn',
                  style: TextStyle(fontSize: 16),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Quay lại',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  Future<void> showModalConfirmRequest({
    required BuildContext context,
  }) async {
    final currentUser = anotherUserController.anotherUserData?.data;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(currentUser?.avatar ??
                    "https://ui-avatars.com/api/?name=${currentUser?.fullName}&background=random"),
              ),
            ],
          ),
          message: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Kết bạn với ${currentUser?.fullName}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
                // isDestructiveAction: true,
                onPressed: () async => await postAcceptFriend(context),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async => await postDeclineFriend(
                    context,
                  )),
        );
      },
    );
  }

  List<Data> followers = [];
  Future<void> getFollowers() async {
    followers.clear();
    notifyListeners();
    final data = await userUseCase.getFollowers(userId);
    List<dynamic> followerJson = data['data'];
    await mapFollowerFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFollowerFromJson(List<dynamic> followerJson) async {
    followers = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
  }

  List<Data> friends = [];
  Future<void> getFriends() async {
    final data = await userUseCase.getFriends(userId);
    List<dynamic> followerJson = data['data'];
    await mapFriendsFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFriendsFromJson(List<dynamic> followerJson) async {
    friends = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
  }

  Future<void> showUserFollowed(BuildContext context) async {
    final index = ref.watch(indexControllerProvider.notifier);

    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    // await getUserLikePost(postId);
    index.setBottomNavigationBarVisibility(false);
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * .7,
        child: UserListPage(
          userId: userId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  Future<void> showUserFriends(BuildContext context) async {
    final index = ref.watch(indexControllerProvider.notifier);

    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    // await getUserLikePost(postId);
    index.setBottomNavigationBarVisibility(false);
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * .7,
        child: UserFriendPage(
          userId: userId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  Future<void> cancelRequest(BuildContext context) async {
    // await anotherUserController.getUserById(userId);
    AppUtils.futureApi(() async {
      final currentUser = anotherUserController.anotherUserData;
      await connectionUseCase.deleteCancelRequest(userId).then((val) async {
        await anotherUserController.getUserById(userId);
        showSnackBar(
            "Đã hủy lời mời kết bạn với ${currentUser?.data?.fullName}");
      }).catchError((e) async {
        await anotherUserController.getUserById(userId);
      });
      // if (currentUser?.data?.friendStatus != "is_friend") {
      //
    }, context, (val) {});
    // }
  }

  Future<void> unFriend(BuildContext context) async {
    final currentUser = anotherUserController.anotherUserData;
    await connectionUseCase.deleteUnFriend(userId).then((val) async {
      await anotherUserController.getUserById(userId);
      context.pop();
      showSnackBar("Đã hủy kết bạn với ${currentUser?.data?.fullName}");
    }).catchError((e) async {
      await anotherUserController.getUserById(userId);
      context.pop();
    });
  }

  Future<void> showModalConnect({
    required BuildContext context,
  }) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: () async {
                  context.pop();
                  await postFollow(context);
                },
                child: const Text(
                  'Theo dõi',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            Visibility(
              // visible: currentUser,
              child: CupertinoActionSheetAction(
                  // isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await postAddFriend(context);
                  },
                  child: const Text(
                    'Thêm bạn bè',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  Future<void> showModalFollowing({
    required BuildContext context,
  }) async {
    final currentUser = anotherUserController.anotherUserData;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            Visibility(
              visible: currentUser?.data?.friendStatus != "sent_request",
              replacement: CupertinoActionSheetAction(
                  onPressed: () async {
                    context.pop();
                    await cancelRequest(context);
                  },
                  child: const Text(
                    'Hủy yêu cầu',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              child: CupertinoActionSheetAction(
                  onPressed: () async {
                    context.pop();
                    await postAddFriend(context);
                  },
                  child: const Text(
                    'Thêm bạn bè',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ),
            Visibility(
              // visible: currentUser,
              child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await postFollow(context);
                  },
                  child: const Text(
                    'Bỏ theo dõi',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  Future<void> showModalSentRequest({
    required BuildContext context,
  }) async {
    final currentUser = anotherUserController.anotherUserData;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            Visibility(
              visible: currentUser?.data?.friendStatus != "sent_request",
              replacement: CupertinoActionSheetAction(
                  onPressed: () async {
                    context.pop();
                    await cancelRequest(context);
                  },
                  child: const Text(
                    'Hủy yêu cầu',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              child: CupertinoActionSheetAction(
                  onPressed: () async {
                    context.pop();
                    await postAddFriend(context);
                  },
                  child: const Text(
                    'Thêm bạn bè',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ),
            Visibility(
              visible: currentUser?.data?.followed == true,
              replacement: CupertinoActionSheetAction(
                  isDestructiveAction: false,
                  onPressed: () async {
                    context.pop();
                    await postFollow(context);
                  },
                  child: const Text(
                    'Theo dõi',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await postFollow(context);
                  },
                  child: const Text(
                    'Bỏ theo dõi',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  Future<void> showModalDelete({
    required BuildContext context,
  }) async {
    final currentUser = anotherUserController.anotherUserData;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            Visibility(
              visible: currentUser?.data?.followed == true,
              replacement: CupertinoActionSheetAction(
                  isDestructiveAction: false,
                  onPressed: () async {
                    context.pop();
                    await postFollow(context);
                  },
                  child: const Text(
                    'Theo dõi',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
              child: CupertinoActionSheetAction(
                  isDestructiveAction: false,
                  onPressed: () async {
                    context.pop();
                    await postFollow(context);
                  },
                  child: const Text(
                    'Bỏ theo dõi',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ),
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {
                  context.pop();
                  await showModalDeleteFriend(context: context);
                },
                child: const Text(
                  'Hủy kết bạn',
                  style: TextStyle(fontSize: 16),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }
}

final userConnectionControllerProvider =
    ChangeNotifierProviderFamily<UserConnectionController, String>(
        (ref, userId) {
  final userUseCase = ref.watch(userUseCaseProvider);
  final userConnectionUseCase = ref.watch(userConnectionUseCaseProvider);
  final anotherUserController = ref.watch(anotherUserControllerProvider);
  return UserConnectionController(
      userConnectionUseCase, ref, userUseCase, anotherUserController, userId);
});
