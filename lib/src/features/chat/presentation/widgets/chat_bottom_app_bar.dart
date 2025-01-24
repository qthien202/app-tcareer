import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_emoji.dart';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget chatBottomAppBar(WidgetRef ref, BuildContext context,
    {bool autoFocus = true}) {
  // final controller = ref.watch(commentControllerProvider);
  final media = ref.watch(chatMediaControllerProvider);

  final controller = ref.watch(chatControllerProvider);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 8), // Thêm padding để tạo không gian
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // Đặt align cho Row
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      controller.setIsShowEmoJi(context);
                    },
                    child: Visibility(
                      visible: controller.isShowEmoji,
                      replacement: const PhosphorIcon(
                        PhosphorIconsRegular.smiley,
                        color: Colors.grey,
                        size: 33,
                      ),
                      child: const PhosphorIcon(
                        PhosphorIconsRegular.keyboard,
                        color: Colors.grey,
                        size: 33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: chatInput(
                autoFocus: autoFocus,
                ref,
                context,
                onChanged: controller.setHasContent,
                onTap: () {
                  if (controller.isShowEmoji == true) {
                    controller.setIsShowEmoJi(context);
                  }
                  if (controller.isShowMedia == true) {
                    controller.setIsShowMedia(context);
                  }
                },
              ),
            ),
            Visibility(
              visible: controller.hasContent || media.selectedAsset.isNotEmpty,
              replacement: GestureDetector(
                onTap: () async {
                  await media.getAlbums();
                  await controller.setIsShowMedia(context);
                },
                child: Visibility(
                  visible: controller.isShowMedia,
                  replacement: const PhosphorIcon(
                    PhosphorIconsRegular.image,
                    color: Colors.grey,
                    size: 33,
                  ),
                  child: const PhosphorIcon(
                    PhosphorIconsRegular.image,
                    color: Colors.blue,
                    size: 33,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (!controller.isShowMedia) {
                    await controller.sendMessage(context);
                  } else {
                    await media.getAssetPaths(context);
                    await media.uploadMedia(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(
                      8), // Thêm padding để làm cho nút đẹp hơn
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      chatEmoji(ref, context)
    ],
  );
}
