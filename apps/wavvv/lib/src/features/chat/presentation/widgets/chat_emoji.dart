import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/content/v2_1.dart';

Widget chatEmoji(WidgetRef ref, BuildContext context) {
  final controller = ref.watch(chatControllerProvider);
  return Visibility(
    visible: controller.isShowEmoji,
    child: EmojiPicker(
      textEditingController: controller.contentController,
      onEmojiSelected: (category, emoji) {
        controller.setHasContent(emoji.toString());
      },
      onBackspacePressed: () {
        controller.setIsShowEmoJi(context);
      },
      config: Config(
        height: ScreenUtil().screenHeight * .32,
        checkPlatformCompatibility: true,
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: const CategoryViewConfig(),
        bottomActionBarConfig: const BottomActionBarConfig(),
        searchViewConfig: const SearchViewConfig(),
      ),
    ),
  );
}
