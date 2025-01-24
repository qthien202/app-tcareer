import 'dart:io';

import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_loading_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/shared_post_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/information_loading.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/posted_job_user.dart';
import 'package:app_tcareer/src/features/user/presentation/widgets/resume_user.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(userControllerProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: userInfo()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: GestureDetector(
                      onTap: () => context.pushNamed("accountSetting"),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Thiết lập tài khoản",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicatorWeight: 2,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.black,
                      labelStyle: const TextStyle(color: Colors.black),
                      tabs: const [
                        Tab(text: "Thông tin"),
                        Tab(text: "Hoạt động"),
                        Tab(text: "Việc làm"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TabBarView(
                children: [
                  const ResumeUser(),
                  postList(),
                  const PostedJobUser()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    final controller = ref.watch(userControllerProvider);
    final user = controller.userData?.data;
    return Visibility(
      visible: controller.userData != null,
      replacement: informationLoading(),
      child: information(
          ref: ref,
          context: context,
          userId: user?.id.toString(),
          friends: user?.friendCount.toString(),
          fullName: user?.fullName ?? "",
          avatar: user?.avatar,
          follows: user?.followerCount.toString()),
    );
  }

  Widget postList() {
    final controller = ref.watch(userControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height, // Đảm bảo chiều cao
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 50) {
            controller.loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refresh(),
            ),
            SliverVisibility(
              visible: controller.postData != null,
              replacementSliver: postLoadingWidget(context),
              sliver: SliverVisibility(
                visible: controller.postCache.isNotEmpty,
                replacementSliver: SliverToBoxAdapter(
                  child: emptyWidget("Không có bài viết nào"),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = controller.postCache[index];
                      final sharedPost = post.sharedPost;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Visibility(
                              replacement: sharedPostWidget(
                                privacyOrigin: sharedPost?.privacy ?? "",
                                onLike: () async =>
                                    await controller.postLikePost(
                                        index: index,
                                        postId: post.id.toString()),
                                originUserId:
                                    sharedPost?.userId.toString() ?? "",
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
                                onLike: () async =>
                                    await controller.postLikePost(
                                        index: index,
                                        postId: post.id.toString()),
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
                          // if (index < controller.postCache.length - 1)
                          //   Divider(height: 1, color: Colors.grey.shade100),
                        ],
                      );
                    },
                    childCount: controller.postCache.length,
                  ),
                ),
              ),
            ),
            if (controller.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: circularLoadingWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: 0.0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
