import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_edit.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/video_player_widget.dart';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:readmore/readmore.dart';
import '../../data/models/shared_post.dart';
import 'engagement_widget.dart';

Widget sharedPostWidget(
    {required void Function() onLike,
    required String userId,
    required String originUserId,
    required BuildContext context,
    required WidgetRef ref,
    required String avatarUrl,
    required String userName,
    required String userNameOrigin,
    required String avatarUrlOrigin,
    String? subName,
    required String createdAt,
    required String originCreatedAt,
    required String? content,
    required String contentOrigin,
    List<String>? mediaUrl,
    required bool liked,
    required String likes,
    required String comments,
    required String shares,
    required String postId,
    required String originPostId,
    required int index,
    required String privacy,
    required String privacyOrigin}) {
  final hasMediaUrl = mediaUrl != null && mediaUrl.isNotEmpty;
  final firstMediaUrl = hasMediaUrl ? mediaUrl.first : "";
  final controller = ref.read(postControllerProvider);
  final postingController = ref.watch(postingControllerProvider);
  final userController = ref.watch(userControllerProvider);
  Map<String, dynamic> privacyIcon = {
    "Public": Icons.public,
    "Friend": Icons.group,
    "Private": Icons.lock
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    width: ScreenUtil().screenWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => controller.goToProfile(
                              userId: userId, context: context),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => controller.goToProfile(
                            userId: userId, context: context),
                        child: Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (subName != null) ...[
                        Text(subName, style: TextStyle(color: Colors.grey)),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "$createdAt • ",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                          ),
                          Icon(
                            privacyIcon[privacy],
                            color: Colors.grey,
                            size: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: userController.userData?.data?.id ==
                              int.parse(userId),
                          replacement: InkWell(
                            onTap: () async {
                              await controller.showHiddenPostConfirm(
                                  context: context, postId: postId);
                            },
                            child: const PhosphorIcon(
                              PhosphorIconsLight.x,
                              color: Colors.grey,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              final post = CreatePostRequest(
                                  body: content, privacy: privacy);

                              final sharedPost = SharedPost(
                                  avatar: avatarUrlOrigin,
                                  fullName: userNameOrigin,
                                  mediaUrl: mediaUrl,
                                  privacy: privacy,
                                  createdAt: originCreatedAt,
                                  body: contentOrigin);
                              final postEdit =
                                  PostEdit(post: post, sharedPost: sharedPost);

                              postingController.showModalPost(
                                  postId: postId,
                                  context: context,
                                  userId: userId,
                                  postEdit: postEdit);
                            },
                            child: const PhosphorIcon(
                              PhosphorIconsLight.dotsThreeCircle,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Hiển thị video hoặc ảnh
            Visibility(
              visible: content != "",
              replacement: const SizedBox(
                height: 10,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contentWidget(content ?? ""),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () => context
                  .goNamed("detail", pathParameters: {"id": originPostId}),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: postWidget(
                      onLike: onLike,
                      userId: originUserId,
                      mediaUrl: mediaUrl,
                      isShared: true,
                      context: context,
                      ref: ref,
                      avatarUrl: avatarUrlOrigin,
                      userName: userNameOrigin,
                      createdAt: originCreatedAt,
                      content: contentOrigin,
                      liked: liked,
                      likes: likes,
                      comments: comments,
                      shares: shares,
                      postId: postId,
                      index: index,
                      privacy: privacy),
                ),
              ),
            ),
            const SizedBox(height: 5),
            engagementWidget(
                onLike: onLike,
                index: index,
                liked: liked,
                ref: ref,
                postId: postId,
                context: context,
                likeCount: likes,
                shareCount: shares,
                originPostId: originPostId),
          ],
        ),
      ],
    ),
  );
}
