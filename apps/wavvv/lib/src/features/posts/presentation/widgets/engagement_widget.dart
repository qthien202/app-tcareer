import 'dart:ui';
import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/comments_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget engagementWidget(
    {required void Function() onLike,
    required WidgetRef ref,
    required int index,
    required bool liked,
    required String postId,
    String? originPostId,
    required BuildContext context,
    required String likeCount,
    required String shareCount}) {
  final indexController = ref.watch(indexControllerProvider.notifier);
  final controller = ref.watch(postControllerProvider.notifier);
  double sizeButton = 22;
  return Padding(
    padding: EdgeInsets.only(left: 8, right: 8, top: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onLike,
              child: Row(
                children: [
                  PhosphorIcon(
                    liked != true
                        ? PhosphorIconsRegular.heart
                        : PhosphorIconsFill.heart,
                    color: liked != true ? Colors.grey : Colors.red,
                    size: sizeButton,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Visibility(
                    visible: likeCount != "0",
                    child: Text(
                      likeCount,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: GestureDetector(
                  onTap: () => indexController.showBottomSheet(
                      context: context,
                      builder: (scrollController) => CommentsPage(
                            postId: int.parse(postId),
                            scrollController: scrollController,
                          )),
                  child: StreamBuilder(
                    stream: controller.commentsStream(postId),
                    builder: (context, snapshot) {
                      final commentCount = snapshot.data?.length;
                      return Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIconsRegular.chatCircleDots,
                            color: Colors.grey,
                            size: sizeButton,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Visibility(
                            visible: commentCount != 0 && snapshot.hasData,
                            child: Text(
                              "$commentCount",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () async {
                        String id = originPostId ?? postId;
                        controller.showSharePage(context, int.parse(id));
                      },
                      child: const ListTile(
                        title: Text("Tạo bài đăng"),
                        trailing: PhosphorIcon(
                          PhosphorIconsLight.notePencil,
                          color: Colors.black,
                        ),
                      )),
                  PopupMenuItem(
                      onTap: () async {
                        String id = originPostId ?? postId;
                        controller.shareLink(
                            title: "Chia sẻ bài viết này",
                            url: "https://tcareer.thientech.site/detail/$id");
                      },
                      child: const ListTile(
                        title: Text("Thêm"),
                        trailing: PhosphorIcon(
                          PhosphorIconsLight.dotsThreeCircle,
                          color: Colors.black,
                        ),
                      )),
                ];
              },
              child: Row(
                children: [
                  PhosphorIcon(
                    PhosphorIconsRegular.paperPlaneTilt,
                    color: Colors.grey,
                    size: sizeButton,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Visibility(
                    visible: shareCount != "0",
                    child: Text(
                      shareCount,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: likeCount != "0",
          child: GestureDetector(
            onTap: () => controller.showUserLiked(context, int.parse(postId)),
            child: Text(
              "Xem lượt thích",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    ),
  );
}
