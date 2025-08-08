import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/post_detail_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/comments_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final getPostByIdProvider =
    FutureProvider.family<PostsDetailResponse, String>((ref, postId) {
  final postUseCase = ref.watch(postUseCaseProvider);
  return postUseCase.getPostById(postId);
});

class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;
  final String? notificationType;
  const PostDetailPage(this.postId, {super.key, this.notificationType});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(postDetailControllerProvider).getPostById(widget.postId);
      print(">>>>>>>>>>>>>>>type1: ${widget.notificationType}");
      if (widget.notificationType?.contains("COMMENT") == true) {
        final indexController = ref.watch(indexControllerProvider.notifier);
        indexController.showBottomSheet(
            context: context,
            builder: (scrollController) => CommentsPage(
                  postId: int.parse(widget.postId),
                  scrollController: scrollController,
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postDetailControllerProvider);
    final post = controller.postData;
    final sharedPost = post?.sharedPost;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: const Text("Bài viết"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back)),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(5),
          //   child: Divider(
          //     color: Colors.grey.shade200,
          //   ),
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () => controller.getPostById(widget.postId),
              ),
              SliverVisibility(
                visible: post != null,
                replacementSliver: SliverToBoxAdapter(
                  child: circularLoadingWidget(),
                ),
                sliver: SliverVisibility(
                    visible: post?.sharedPostId == null,
                    replacementSliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: 1,
                        (context, index) {
                          return sharedPostWidget(
                              privacyOrigin: sharedPost?.privacy ?? "",
                              onLike: () async =>
                                  controller.likePostById(widget.postId),
                              originUserId: sharedPost?.userId.toString() ?? "",
                              userId: post?.userId.toString() ?? "",
                              originCreatedAt: sharedPost?.createdAt ?? "",
                              originPostId: sharedPost?.id.toString() ?? "",
                              mediaUrl: sharedPost?.mediaUrl,
                              context: context,
                              ref: ref,
                              avatarUrl: post?.avatar ??
                                  "https://ui-avatars.com/api/?name=${post?.fullName}&background=random",
                              userName: post?.fullName ?? "",
                              userNameOrigin: sharedPost?.fullName ?? "",
                              avatarUrlOrigin: sharedPost?.avatar ??
                                  "https://ui-avatars.com/api/?name=${sharedPost?.fullName}&background=random",
                              createdAt: post?.createdAt ?? "",
                              content: post?.body ?? "",
                              contentOrigin: sharedPost?.body ?? "",
                              liked: post?.liked ?? false,
                              likes: post?.likeCount?.toString() ?? "0",
                              comments: post?.commentCount?.toString() ?? "0",
                              shares: post?.shareCount?.toString() ?? "0",
                              privacy: post?.privacy ?? "",
                              postId: post?.id.toString() ?? "",
                              index: 0);
                        },
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: 1,
                        (context, index) {
                          return postWidget(
                              onLike: () async =>
                                  controller.likePostById(widget.postId),
                              userId: post?.userId.toString() ?? "",
                              index: 0,
                              liked: post?.liked ?? false,
                              privacy: post?.privacy ?? "",
                              postId: post?.id.toString() ?? "",
                              ref: ref,
                              context: context,
                              avatarUrl: post?.avatar ??
                                  "https://ui-avatars.com/api/?name=${post?.fullName}&background=random",
                              userName: post?.fullName ?? "",
                              createdAt: post?.createdAt ?? "",
                              content: post?.body ?? "",
                              mediaUrl: post?.mediaUrl ?? [],
                              likes: post?.likeCount != null
                                  ? "${post?.likeCount}"
                                  : "0",
                              comments: post?.commentCount != null
                                  ? "${post?.commentCount}"
                                  : "0",
                              shares: post?.shareCount != null
                                  ? "${post?.shareCount}"
                                  : "0");
                        },
                      ),
                    )),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 40,
                ),
              )
            ],
          ),
        ));
  }
}
