import 'package:app_tcareer/src/features/jobs/chat/presentation/controllers/job_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget jobChatInput(WidgetRef ref, BuildContext context,
    {void Function(String)? onChanged,
    void Function()? onTap,
    bool autoFocus = true}) {
  final controller = ref.watch(jobChatControllerProvider);

  return Container(
    // padding: EdgeInsets.a,
    child: TextField(
      onTap: onTap,
      autofocus:
          controller.isShowMedia || controller.isShowEmoji ? false : true,
      controller: controller.contentController,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        hintText: "Nhập tin nhắn...",
        hintStyle: const TextStyle(fontSize: 14),
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    ),
  );
}
