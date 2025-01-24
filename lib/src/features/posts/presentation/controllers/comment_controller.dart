import 'dart:async';
import 'dart:io';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/edit_comment_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/user_liked_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class CommentController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final MediaUseCase mediaUseCase;
  final Ref ref;
  final CommentUseCase commentUseCase;
  bool isDisposed = false;
  StreamSubscription? commentSubscription;
  CommentController(
      this.postUseCase, this.ref, this.commentUseCase, this.mediaUseCase);
  TextEditingController contentController = TextEditingController();
  TextEditingController editContentController = TextEditingController();

  Future<void> postCreateComment({
    required int postId,
    required BuildContext context,
  }) async {
    if (isDisposed) return; // Kiểm tra xem controller đã bị dispose chưa

    final mediaController = ref.watch(mediaControllerProvider);
    if (mediaController.videoPaths != null) {
      await AppUtils.loadingApi(() async => await uploadVideo(), context);
    }

    if (mediaController.imagePaths.isNotEmpty) {
      await AppUtils.loadingApi(() async => await uploadImageFile(), context);
    }
    postUseCase.postCreateComment(
      postId: postId,
      content: contentController.text,
      parentId: parentId,
      mediaUrl: mediaUrl,
    );
    contentController.clear();
    clearRepComment();
    mediaController.removeAssets();

    FocusScope.of(context).unfocus();

    // Chỉ gọi clear nếu chưa dispose
  }

  bool hasContent = false;
  void setHasContent(String value) {
    if (value.isNotEmpty) {
      hasContent = true;
    } else {
      hasContent = false;
    }
    notifyListeners();
  }

  String? userName;
  int? parentId;
  void setRepComment({required int commentId, required String fullName}) {
    parentId = null;
    userName = fullName;
    parentId = commentId;

    notifyListeners();
  }

  Map<dynamic, dynamic>? commentData;
  Future<void> getCommentByPostId(String postId) async {
    commentData = await commentUseCase.getCommentByPostId(postId);

    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isDisposed = true;
    commentSubscription?.cancel();
    contentController.dispose();
    commentVisibility.clear();
    super.dispose();
  }

  // void listenToComments(String postId) {
  //   commentSubscription =
  //       commentUseCase.listenToComment(postId).listen((event) {
  //     if (event.snapshot.value != null) {
  //       commentData = event.snapshot.value as Map<dynamic, dynamic>;
  //     }
  //   });
  // }
  List<MapEntry<dynamic, dynamic>> getCommentChildren(
      int parentId, List<MapEntry<dynamic, dynamic>> commentData) {
    final directChildren = commentData
        .where((entry) => entry.value['parent_id'] == parentId)
        .toList();

    List<MapEntry<dynamic, dynamic>> allChildren = [];
    for (var child in directChildren) {
      allChildren.add(child);
      allChildren.addAll(getCommentChildren(int.parse(child.key), commentData));
    }
    return allChildren;
  }

  Stream<Map<dynamic, dynamic>> commentsStream(String postId) {
    return commentUseCase.listenToComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final commentMap = event.snapshot.value as Map<dynamic, dynamic>;

        print(">>>>>>>>>>>>>>data: $commentMap"); // Kiểm tra dữ liệu

        final sortedComments = commentMap.entries.toList()
          ..sort((a, b) {
            final createdA = DateTime.parse(
                AppUtils.convertToISOFormat(a.value['created_at']));
            final createdB = DateTime.parse(
                AppUtils.convertToISOFormat(b.value['created_at']));
            return (createdB).compareTo(createdA);
          });

        return {for (var e in sortedComments) e.key: e.value};
      } else {
        return {};
      }
    });
  }

  Future<void> pickMedia() async {
    await mediaUseCase.pickMediaWeb();
  }

  void clearRepComment() {
    userName = null;
    parentId = null;

    notifyListeners();
  }

  List<String> mediaUrl = [];
  Future<void> uploadVideo() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);

    if (mediaController.videoPaths.isNotEmpty) {
      String videoUrl = await postUseCase.uploadFile(
        topic: "comment",
        folderName: "video",
        file: File(mediaController.videoPaths.first),
      );

      mediaUrl.add(videoUrl);
    }
  }

  Future<void> uploadImageFile() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = const Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.imagePaths) {
      String? assetPath = await AppUtils.compressImage(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFileFireBase(
          file: File(assetPath ?? ""), folderPath: "Comments/$id");
      mediaUrl.add(url);
    }
    // notifyListeners();
  }

  Map<int, bool> commentVisibility = {};

  void toggleCommentVisibility(int commentId) {
    commentVisibility[commentId] = !(commentVisibility[commentId] ?? false);
    notifyListeners();
  }

  bool isLiking = false;
  Future<void> postLikeComment(String commentId) async {
    await commentUseCase.postLikeComment(commentId);
    // await Future.delayed(Duration(milliseconds: 300));
  }

  Stream<Map<dynamic, dynamic>> likeCommentsStream(String postId) {
    return commentUseCase.listenToLikeComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final likesComment = event.snapshot.value as Map<dynamic, dynamic>;

        // Sắp xếp bình luận

        // Tạo bản đồ đã sắp xếp
        return likesComment;
      } else {
        return {};
      }
    });
  }

  UserLiked? userLiked;
  Future<void> getUserLikeComment(int commentId) async {
    userLiked = null;
    notifyListeners();
    userLiked = await commentUseCase.getUserLikeComment(commentId);
    notifyListeners();
  }

  Future<void> showUserLiked(BuildContext context, int commentId) async {
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
        child: UserLikedPage(
          commentId: commentId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  Future<void> showModalComment(
      {required String postId,
      required BuildContext context,
      required String userId,
      required String commentUserId,
      required int commentId,
      required String content,
      required String fullName}) async {
    bool currentUser = userId == commentUserId;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: () {
                  context.pop();
                  setRepComment(commentId: commentId, fullName: fullName);
                },
                child: const Text(
                  'Trả lời',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            Visibility(
              visible: currentUser,
              child: CupertinoActionSheetAction(
                  onPressed: () {
                    context.pop();
                    showEditPage(
                        context, postId, commentId.toString(), content);
                  },
                  child: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ),
            Visibility(
              visible: currentUser,
              child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await showDialogDeleteComment(
                        context, commentId.toString());
                  },
                  child: const Text(
                    'Xóa',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
            CupertinoActionSheetAction(
                onPressed: () => copyComment(content, context),
                child: const Text(
                  'Sao chép',
                  style: TextStyle(fontSize: 16, color: Colors.black),
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

  Future<void> showDialogDeleteComment(
      BuildContext context, String commentId) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Xóa bình luận",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Bạn có chắc chắn muốn xóa bình luận này không?"),
          actions: [
            CupertinoDialogAction(
                onPressed: () => context.pop(),
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: Colors.blue),
                )),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await deleteComment(commentId, context);
                },
                child: const Text(
                  'Xóa',
                )),
          ],
        );
      },
    );
  }

  void copyComment(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showSnackBar("Sao chép bình luận thành công!");
      context.pop();
    });
  }

  Future<void> deleteComment(String commentId, BuildContext context) async =>
      AppUtils.loadingApi(() async {
        await commentUseCase.deleteComment(commentId);
        context.pop();
      }, context);

  Future<void> showEditPage(BuildContext context, String postId,
      String commentId, String content) async {
    editContentController.text = content;

    final index = ref.watch(indexControllerProvider.notifier);
    // index.showBottomSheet(
    //     context: context, builder: (scrollController) => SharePage());
    index.setBottomNavigationBarVisibility(false);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditCommentPage(
          postId: postId,
          commentId: commentId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  Future<void> updateComment(
      {required String commentId,
      required String postId,
      required BuildContext context}) async {
    AppUtils.loadingApi(() async {
      await commentUseCase.putUpdateComment(
          commentId: commentId,
          postId: postId,
          content: editContentController.text);
      context.pop();
      editContentController.clear();
    }, context);
  }
}
