import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_edit.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/engagement_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/posting_image_wiget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/posting_video_player_widget.dart';
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

Widget postTemp({
  bool isShared = false,
  required String userId,
  required BuildContext context,
  required WidgetRef ref,
  required String avatarUrl,
  required String userName,
  String? subName,
  required String createdAt,
  required String? content,
  List<String>? mediaUrl,
  required bool liked,
  required String likes,
  required String comments,
  required String shares,
  required String postId,
  required int index,
  required String privacy,
}) {
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
        child: Container(
          padding: !isShared ? const EdgeInsets.symmetric(vertical: 15) : null,
          // margin: !isShared ? const EdgeInsets.symmetric(horizontal: 10) : null,
          decoration: !isShared
              ? BoxDecoration(
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
                )
              : null,
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
                              onTap: null,
                              child: Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (subName != null) ...[
                              Text(subName,
                                  style: const TextStyle(color: Colors.grey)),
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
                          child: Visibility(
                            replacement: Visibility(
                              visible: !isShared,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: null,
                                    child: PhosphorIcon(
                                      PhosphorIconsLight.x,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            visible: !isShared &&
                                userController.userData?.data?.id ==
                                    int.parse(userId),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final post = CreatePostRequest(
                                        body: content,
                                        mediaUrl: mediaUrl,
                                        privacy: privacy);
                                    final postEdit = PostEdit(post: post);
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Hiển thị video hoặc ảnh
                  Visibility(
                    visible: content != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          contentWidget(content ?? ""),
                        ],
                      ),
                    ),
                  ),

                  Visibility(
                    visible: hasMediaUrl,
                    child: postingImageWidget(
                        mediaUrl: mediaUrl ?? [],
                        ref: ref,
                        visibleDelete: false),
                  ),

                  // Visibility(
                  //     visible: !isShared,
                  //     child: engagementWidget(
                  //       onLike: () {},
                  //       index: index,
                  //       liked: liked,
                  //       ref: ref,
                  //       postId: postId,
                  //       context: context,
                  //       likeCount: likes,
                  //       shareCount: shares,
                  //     ))
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget contentWidget(String content) {
  return ReadMoreText(
    content,
    trimMode: TrimMode.Line,
    trimLines: 2,
    colorClickableText: Colors.black,
    trimCollapsedText: "Xem thêm",
    trimExpandedText: "Thu gọn",
    moreStyle: const TextStyle(fontWeight: FontWeight.bold),
  );
}
