import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  final String query;
  const SearchResultPage(this.query, {super.key});

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final searchPostController = ref.read(searchPostControllerProvider);
      searchPostController.posts.clear();
      searchPostController.search(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(searchPostControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: searchBarWidget(
          readOnly: true,
          onTap: () => context.pushReplacementNamed("search"),
          controller: controller.queryController,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Visibility(
        visible: !controller.isLoading,
        replacement: circularLoadingWidget(),
        child: Visibility(
          visible: controller.users.isNotEmpty || controller.posts.isNotEmpty,
          replacement: emptyWidget("Không tìm thấy dữ liệu"),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller.scrollController,
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async => await controller.refresh(),
                ),
                SliverVisibility(
                  visible: controller.users.isNotEmpty,
                  sliver: const SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Mọi người",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                userList(),
                SliverVisibility(
                  visible: controller.users.isNotEmpty,
                  sliver: SliverToBoxAdapter(
                      child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: ScreenUtil().screenWidth,
                    color: Colors.grey.shade100,
                    height: 10,
                  )),
                ),
                SliverVisibility(
                  visible: controller.posts.isNotEmpty,
                  sliver: const SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Bài viết",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                postList(),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: controller.posts.isNotEmpty &&
                        controller.posts.length !=
                            controller.postData?.meta?.total,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: circularLoadingWidget(),
                    ),
                  ),
                )
                // postList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userList() {
    final controller = ref.watch(searchPostControllerProvider);
    final postController = ref.watch(postControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final user = controller.users[index];
          return ListTile(
              tileColor: Colors.white,
              onTap: () => postController.goToProfile(
                  context: context, userId: user.id.toString()),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar ??
                    "https://ui-avatars.com/api/?name=${user.fullName}&background=random"),
              ),
              title: Text(user.fullName ?? ""),
              trailing: Icon(
                size: 20,
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
              ));
        },
        childCount: controller.users.length, // Số lượng người dùng
      ),
    );
  }

  Widget postList() {
    final controller = ref.watch(searchPostControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final post = controller.posts[index];
        final sharedPost = post.sharedPost;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Visibility(
                replacement: sharedPostWidget(
                    privacyOrigin: sharedPost?.privacy ?? "",
                    onLike: () async => await controller.postLikePost(
                        index: index, postId: post.id.toString()),
                    originUserId: sharedPost?.userId.toString() ?? "",
                    userId: post.userId.toString(),
                    originCreatedAt: sharedPost?.createdAt ?? "",
                    originPostId: sharedPost?.id.toString() ?? "",
                    mediaUrl: sharedPost?.mediaUrl,
                    context: context,
                    ref: ref,
                    avatarUrl: post.avatar ??
                        "https://ui-avatars.com/api/?name=${post.fullName}&background=random",
                    userName: post.fullName ?? "",
                    userNameOrigin: sharedPost?.fullName ?? "",
                    avatarUrlOrigin: sharedPost?.avatar ??
                        "https://ui-avatars.com/api/?name=${sharedPost?.fullName}&background=random",
                    createdAt: post.createdAt ?? "",
                    content: post.body ?? "",
                    contentOrigin: sharedPost?.body ?? "",
                    liked: post.liked ?? false,
                    likes: post.likeCount?.toString() ?? "0",
                    comments: post.commentCount?.toString() ?? "0",
                    shares: post.shareCount?.toString() ?? "0",
                    privacy: post.privacy ?? "",
                    postId: post.id.toString(),
                    index: index),
                visible: post.sharedPostId == null,
                child: postWidget(
                  onLike: () async => await controller.postLikePost(
                      index: index, postId: post.id.toString()),
                  userId: post.userId.toString(),
                  index: index,
                  liked: post.liked ?? false,
                  privacy: post.privacy ?? "",
                  postId: post.id.toString(),
                  ref: ref,
                  context: context,
                  avatarUrl: post.avatar ??
                      "https://ui-avatars.com/api/?name=${post.fullName}&background=random",
                  userName: post.fullName ?? "",
                  createdAt: post.createdAt ?? "",
                  content: post.body ?? "",
                  mediaUrl: post.mediaUrl,
                  likes: post.likeCount?.toString() ?? "0",
                  comments: post.commentCount?.toString() ?? "0",
                  shares: post.shareCount?.toString() ?? "0",
                ),
              ),
            ),
            // if (index < controller.posts.length - 1)
            //   Divider(
            //     height: 1,
            //     color: Colors.grey.shade100,
            //   ),
          ],
        );
      }, childCount: controller.posts.length),
    );
  }
}
