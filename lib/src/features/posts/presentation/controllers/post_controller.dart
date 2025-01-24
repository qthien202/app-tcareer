import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/share_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/user_liked_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class PostController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final ChangeNotifierProviderRef<Object?> ref;
  PostController(this.postUseCase, this.ref) {
    getPost();
    scrollController.addListener(() {
      loadMore();
    });
  }
  post_model.PostsResponse? postData;

  bool _disposed = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> shareLink({required String url, required String title}) async {
    await Share.share(url, subject: title);
  }

  Map<String, int> activeIndexMap = {};

  int pendingLikeCount = 0;
  bool isLikeProcess = false;
  Future<void> postLikePost({
    required int index,
    required String postId,
  }) async {
    if (isLikeProcess) return;
    isLikeProcess = true;
    final currentPost = postCache[index];
    final isLiked = currentPost.liked ?? false;
    final likeCount = currentPost.likeCount ?? 0;
    pendingLikeCount = isLiked ? -1 : 1;
    final updatedPostTemp = currentPost.copyWith(
        liked: !(postCache[index].liked ?? false),
        likeCount: likeCount + pendingLikeCount);

    postCache[index] = updatedPostTemp;
    notifyListeners();
    // setLikePost(index);
    await postUseCase.postLikePost(
        postId: postId, index: index, postCache: postCache);
    isLikeProcess = false;
    notifyListeners();
    pendingLikeCount = 0;
  }

  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];

  Future<void> getPost() async {
    postData = null;
    postData = await postUseCase.getPost(personal: "n");
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();

      postCache.addAll(newPosts as Iterable<post_model.Data>);
      print(">>>>>>>>>>postLength: ${postCache.length}");

      // if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      await getPost();
      notifyListeners();
    }
  }

  void scrollToTop() {
    scrollController.jumpTo(0);
  }

  Future<void> refresh() async {
    postData = null;
    postCache.clear();
    print(">>>>>>>>>>${postCache.length}");
    await getPost();

    // await getPost();
  }

  Stream<Map<dynamic, dynamic>> commentsStream(String postId) {
    final commentUseCase = ref.watch(commentUseCaseProvider);
    return commentUseCase.listenToComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final commentMap = event.snapshot.value as Map<dynamic, dynamic>;
        return commentMap;
      } else {
        return {};
      }
    });
  }

  Future<void> showSharePage(BuildContext context, int postId) async {
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
        child: SharePage(postId),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  UserLiked? userLiked;

  Future<void> getUserLikePost(int postId) async {
    userLiked = null;
    notifyListeners();
    userLiked = await postUseCase.getUserLikePost(postId);
    notifyListeners();
  }

  Future<void> showUserLiked(BuildContext context, int postId) async {
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
          postId: postId,
        ),
      ),
    ).whenComplete(
      () => index.setBottomNavigationBarVisibility(true),
    );
  }

  TextEditingController shareContentController = TextEditingController();
  Future<void> sharePost(
      {required int postId,
      required String privacy,
      required BuildContext context}) async {
    await postUseCase.postSharePost(
        postId: postId, privacy: privacy, body: shareContentController.text);
    shareContentController.clear();

    FocusScope.of(context).unfocus();
    context.pop();
    scrollController.jumpTo(0);
    await refresh();
  }

  void goToProfile({required String userId, required BuildContext context}) {
    final user = ref.watch(userControllerProvider);
    final index = ref.watch(indexControllerProvider.notifier);
    index.setBottomNavigationBarVisibility(true);
    if (user.isCurrentUser(int.parse(userId)) == true) {
      context.goNamed('user');
    } else {
      context.pushNamed('profile', queryParameters: {"userId": userId});
    }
  }

  Future<void> showHiddenPostConfirm(
      {required BuildContext context, required String postId}) async {
    await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: const Text('Bạn có chắc muốn ẩn bài viết này?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Tiếp tục',
              ),
              onPressed: () async =>
                  await hiddenPost(postId: postId, context: context),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Quay lại',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> hiddenPost(
      {required BuildContext context, required String postId}) async {
    AppUtils.futureApi(() async {
      postCache.removeWhere((post) => post.id == int.parse(postId));
      notifyListeners();
      context.pop();
      await postUseCase.hiddenPost(postId);
    }, context, (val) {});
  }
}
