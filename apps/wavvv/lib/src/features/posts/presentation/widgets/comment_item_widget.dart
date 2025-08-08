import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/comment_video_player.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Widget commentItemWidget(int commentId, Map<dynamic, dynamic> comment,
    WidgetRef ref, BuildContext context, String postId) {
  final controller = ref.watch(commentControllerProvider);
  final postController = ref.watch(postControllerProvider);

  String userName = comment['full_name'];
  String content = comment['content'];
  String? avatar = comment['avatar'];
  String createdAt = AppUtils.formatTime(comment['created_at']);
  String? parentName = comment['parent_name'];
  String userId =
      ref.watch(userControllerProvider).userData?.data?.id.toString() ?? "";
  int commentUserId = comment['user_id'] ?? 0;
  int likeCount = comment['like_count'];
  List<String> mediaUrl =
      (comment['media_url'] as List?)?.whereType<String>().toList() ?? [];

  return InkWell(
    onLongPress: () => controller.showModalComment(
      postId: postId,
      userId: userId,
      commentUserId: commentUserId.toString(),
      content: content,
      context: context,
      commentId: commentId,
      fullName: userName.toString(),
    ),
    child: Container(
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                    postController.goToProfile(
                        userId: commentUserId.toString(), context: context);
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(avatar != null
                        ? avatar
                        : "https://ui-avatars.com/api/?name=$userName&background=random"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.pop();
                    postController.goToProfile(
                        userId: commentUserId.toString(), context: context);
                  },
                  child: Visibility(
                    visible: parentName != null,
                    replacement: Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    child: Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Visibility(
                          visible: parentName != userName,
                          replacement: Text(" • "),
                          child: const Icon(
                            Icons.arrow_right_outlined,
                            size: 11,
                          ),
                        ),
                        Visibility(
                          visible: parentName != userName,
                          replacement: const Text(
                            "Tác giả",
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          child: Text(
                            "$parentName",
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: mediaUrl.isNotEmpty,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mediaUrl.map((image) {
                        return Visibility(
                          visible: !mediaUrl.hasVideos,
                          replacement: CommentVideoPlayerWidget(image),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: cachedImageWidget(
                                imageUrl: image,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100),
                          ),
                        );
                      }).toList()),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      createdAt,
                      style:
                          const TextStyle(color: Colors.black38, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus();

                        controller.setRepComment(
                            fullName: userName.toString(),
                            commentId: commentId);
                      },
                      child: const Text(
                        "Trả lời",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                StreamBuilder(
                  stream: controller.likeCommentsStream(postId),
                  builder: (context, snapshot) {
                    print(">>>>>>>data: ${snapshot.data}");
                    final likesCommentData = snapshot.data?.entries.toList();
                    print(">>>>>>>>>>>likeData: $likesCommentData");
                    Map<dynamic, dynamic>? userLikesEntry =
                        likesCommentData?.map((entry) {
                      if (entry.key == commentId.toString()) {
                        return entry.value['user_likes'];
                      }
                    }).firstWhere((value) => value != null, orElse: () => null);
                    print(">>>>>>>>>userLikes: $userLikesEntry");

                    bool hasLiked = userLikesEntry != null
                        ? userLikesEntry.containsKey(userId)
                        : false;

                    return GestureDetector(
                        onTap: () async => await controller
                            .postLikeComment(commentId.toString()),
                        child: Visibility(
                          visible: hasLiked,
                          replacement: const Icon(
                            Icons.favorite_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.red,
                          ),
                        ));
                  },
                ),
                Visibility(
                    visible: likeCount != 0,
                    child: InkWell(
                      onTap: () => controller.showUserLiked(context, commentId),
                      child: Text(
                        "$likeCount",
                        style: TextStyle(fontSize: 12),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
