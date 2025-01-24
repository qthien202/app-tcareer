import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/post_temp.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';

import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:app_tcareer/src/widgets/notification_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Khởi tạo dữ liệu ở đây
    final controller = ref.watch(postControllerProvider);
    final scrollController = ref.read(postControllerProvider).scrollController;
    bool hasData = controller.postCache.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refresh(),
            ),
            sliverAppBar(ref, context),
            SliverVisibility(
              visible: controller.postData != null,
              replacementSliver: postLoadingWidget(context),
              sliver: SliverVisibility(
                visible: controller.postData?.data?.isNotEmpty == true,
                replacementSliver: SliverFillRemaining(
                  child: emptyWidget("Không có bài viết nào"),
                ),
                sliver: sliverPost(ref),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: hasData &&
                    controller.postCache.length !=
                        controller.postData?.meta?.total,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: circularLoadingWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverPost(WidgetRef ref) {
    final controller = ref.watch(postControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = controller.postCache[index];
          final sharedPost = controller.postCache[index].sharedPost;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Visibility(
                  visible: post.title != "temp",
                  replacement: postTemp(
                    userId: post.userId.toString(),
                    index: index,
                    liked: post.liked ?? false,
                    privacy: post.privacy ?? "",
                    postId: post.id.toString(),
                    ref: ref,
                    context: context,
                    avatarUrl: post.avatar ?? "",
                    userName: post.fullName ?? "",
                    createdAt: post.createdAt ?? "",
                    content: post.body ?? "",
                    mediaUrl: post.mediaUrl,
                    likes: post.likeCount?.toString() ?? "0",
                    comments: post.commentCount?.toString() ?? "0",
                    shares: post.shareCount?.toString() ?? "0",
                  ),
                  child: Visibility(
                    replacement: sharedPostWidget(
                      privacyOrigin: sharedPost?.privacy ?? "",
                      onLike: () async => await controller.postLikePost(
                        index: index,
                        postId: post.id.toString(),
                      ),
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
                      index: index,
                    ),
                    visible: post.sharedPostId == null,
                    child: postWidget(
                      onLike: () async => await controller.postLikePost(
                        index: index,
                        postId: post.id.toString(),
                      ),
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
              ),
            ],
          );
        },
        childCount: controller.isLoading ? 5 : controller.postCache.length,
      ),
    );
  }

  Widget sliverAppBar(WidgetRef ref, BuildContext context) {
    final postingController = ref.watch(postingControllerProvider);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false,
      title: const Text(
        "Bài đăng",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => context.goNamed('search'),
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: GestureDetector(
        //     onTap: () => context.pushNamed("conversation"),
        //     child: const PhosphorIcon(
        //       PhosphorIconsRegular.chatCenteredDots,
        //       color: Colors.black,
        //       size: 20,
        //     ),
        //   ),
        // ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
                onTap: () => context.pushNamed("notifications"),
                child: notificationIcon(ref))),
      ],
      bottom: PreferredSize(
        preferredSize: postingController.isLoading == true
            ? const Size.fromHeight(30)
            : const Size.fromHeight(0),
        child: postingLoading(ref),
      ),
    );
  }

  Widget postingLoading(WidgetRef ref) {
    final postingController = ref.watch(postingControllerProvider);
    return Visibility(
      visible: postingController.isLoading == true,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    value: postingController.loadingProgress,
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  postingController.loadingProgress >= 0.75
                      ? "Sắp hoàn tất..."
                      : "Đang tải bài viết lên...",
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Divider(
                color: Colors.grey.shade100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
