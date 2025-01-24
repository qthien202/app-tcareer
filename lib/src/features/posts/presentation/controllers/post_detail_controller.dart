import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailController extends ChangeNotifier {
  final PostUseCase postUseCase;
  PostDetailController(this.postUseCase);

  post.PostsDetailResponse? postsDetailResponse;
  post.Data? postData;
  Future<void> getPostById(String postId) async {
    postsDetailResponse = null;
    postData = null;
    notifyListeners();
    postsDetailResponse = await postUseCase.getPostById(postId);
    postData = postsDetailResponse?.data;
    notifyListeners();
  }

  Future<void> likePostById(String postId) async {
    await setLikePost(postId);
  }

  int pendingLikeCount = 0;
  bool isLikeProcess = false;
  Future<void> setLikePost(String postId) async {
    if (isLikeProcess) return;
    isLikeProcess = true;
    var currentPost = postData;
    final isLiked = postData?.liked ?? false;
    final likeCount = postData?.likeCount ?? 0;
    pendingLikeCount = isLiked ? -1 : 1;

    final updatePostTemp = currentPost?.copyWith(
        liked: !(currentPost.liked ?? false),
        likeCount: likeCount + pendingLikeCount);
    postData = updatePostTemp;
    notifyListeners();

    final likePostData = await postUseCase.postLikePostDetail(postId, 0);
    final updatePost =
        updatePostTemp?.copyWith(likeCount: likePostData.data?.likeCount);

    postData = updatePost;
    isLikeProcess = false;
    notifyListeners();
    pendingLikeCount = 0;
  }
}

final postDetailControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.watch(postUseCaseProvider);
  return PostDetailController(postUseCase);
});
