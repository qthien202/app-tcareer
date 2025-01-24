import 'package:flutter/material.dart';

Widget postInput(
    {int? minLines,
    TextEditingController? controller,
    int? maxLines,
    String? hintText,
    void Function(String)? onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      autofocus: true,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      // Gán focusNode vào TextField
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: hintText ?? "Hôm nay bạn muốn chia sẻ điều gì?",
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none),
    ),
  );
}
