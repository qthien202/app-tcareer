import 'dart:io';

import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_video_player.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:app_tcareer/src/widgets/photos/app_photo_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fb_photo_view/flutter_fb_photo_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget messageBox(
    {required bool isFirstIndex,
    required String status,
    required String avatarUrl,
    required String message,
    String? type,
    bool isMe = false,
    required String createdAt,
    required WidgetRef ref,
    required List<String> media,
    required BuildContext context,
    required num messageId}) {
  Color messageColor = isMe ? const Color(0xff3E66FB) : Colors.white;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
    children: [
      Visibility(
        visible: !isMe,
        child: CircleAvatar(
          radius: 15,
          backgroundImage: CachedNetworkImageProvider(avatarUrl),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Visibility(
        visible: type == "recall",
        child: recallMessage(
            ref: ref,
            createdAt: createdAt,
            status: status,
            isFirstIndex: isFirstIndex,
            isMe: isMe),
      ),
      Visibility(
        visible: message != "",
        child: Expanded(
          child: GestureDetector(
            onLongPress: () {
              ref.read(chatControllerProvider).showModalMessageText(
                  context: context,
                  isMe: isMe,
                  message: message,
                  messageId: messageId);
            },
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: ScreenUtil().screenWidth * .7),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: messageColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                              color: !isMe ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          AppUtils.formatCreatedAt(createdAt),
                          style: TextStyle(
                              color: !isMe ? Colors.black : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isMe && isFirstIndex,
                  child: Visibility(child: statusText(status)),
                )
              ],
            ),
          ),
        ),
      ),
      Visibility(
          visible: media.isNotEmpty,
          child: Expanded(
            child: GestureDetector(
              onLongPress: () {
                ref.read(chatControllerProvider).showModalMessageText(
                    context: context,
                    isMe: isMe,
                    message: message,
                    messageId: messageId);
              },
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: ScreenUtil().screenWidth * .6),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          mediaItem(media, ref, context),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              createdAtText(createdAt),
                              Visibility(
                                visible: isMe && isFirstIndex,
                                child: Visibility(child: statusText(status)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ))
    ],
  );
}

Widget createdAtText(String createdAt) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
        color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
    child: Text(
      AppUtils.formatCreatedAt(createdAt),
      style: const TextStyle(
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
    ),
  );
}

Widget statusText(String status) {
  Map<String, dynamic> statusMap = {
    "sent": "Đã gửi",
    "read": "Đã xem",
    "delivered": "Đã nhận"
  };

  Map<String, dynamic> statusIcon = {
    "sent": PhosphorIconsRegular.check,
    "delivered": PhosphorIconsRegular.checks,
    "read": PhosphorIconsRegular.eye,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
        color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statusMap[status],
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 2,
        ),
        PhosphorIcon(
          statusIcon[status],
          color: Colors.white,
          size: 15,
        ),
      ],
    ),
  );
}

Widget mediaItem(List<String> media, WidgetRef ref, BuildContext context) {
  CarouselController carouselController = CarouselController();
  if (media.length == 1) {
    return Visibility(
      visible: media.first.isImageNetWork,
      replacement: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.black54, BlendMode.darken),
              child: Image.file(
                File(media[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 24, // Kích thước của indicator
            height: 24,
            child: circularLoadingWidget(),
          ),
        ],
      ),
      child: Visibility(
        visible: !media.first.isVideoNetWork,
        replacement: ChatVideoPlayerWidget(media.first),
        child: GestureDetector(
          onTap: () {
            List<String> images =
                media.where((item) => item.isImageNetWork).toList();
            final data = AppPhotoModel(
                images: images,
                onPageChanged: (val) {
                  // carouselController.animateToPage(
                  //   val,
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeInOut,
                  // );
                },
                index: 0);
            context.pushNamed("appPhoto", extra: data);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: cachedImageWidget(
              visiblePlaceHolder: false,
              imageUrl: media[0],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  } else {
    return Wrap(
      // alignment: WrapAlignment.end,
      spacing: 5,
      runSpacing: 5,
      children: media.asMap().entries.map((entry) {
        final mediaItem = entry.value;
        final index = entry.key;
        return Container(
          alignment: Alignment.centerRight,
          // width: (ScreenUtil().screenWidth - 15) / 2,
          child: Visibility(
            visible: mediaItem.isImageNetWork,
            replacement: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                        Colors.black54, BlendMode.darken),
                    child: Image.file(
                      File(mediaItem),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: circularLoadingWidget(),
                ),
              ],
            ),
            child: Visibility(
              visible: !mediaItem.isVideoNetWork,
              replacement: ChatVideoPlayerWidget(
                mediaItem,
              ),
              child: GestureDetector(
                onTap: () {
                  List<String> images =
                      media.where((item) => item.isImageNetWork).toList();
                  final data = AppPhotoModel(
                      images: images,
                      onPageChanged: (val) {
                        // carouselController.animateToPage(
                        //   val,
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        // );
                      },
                      index: index);
                  context.pushNamed("appPhoto", extra: data);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: cachedImageWidget(
                    visiblePlaceHolder: false,
                    imageUrl: mediaItem,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget recallMessage({
  bool isMe = false,
  required String createdAt,
  required String status,
  required bool isFirstIndex,
  required WidgetRef ref,
}) {
  final chatController = ref.watch(chatControllerProvider);
  String? fullName = chatController.user?.userFullName.toString();
  return Expanded(
    child: Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ScreenUtil().screenWidth * .7),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMe
                      ? "Bạn đã thu hồi một tin nhắn"
                      : "$fullName đã thu hồi một tin nhắn",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  AppUtils.formatCreatedAt(createdAt),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isMe && isFirstIndex,
          child: Visibility(child: statusText(status)),
        )
      ],
    ),
  );
}
