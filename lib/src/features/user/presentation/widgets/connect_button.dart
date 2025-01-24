import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget connectButton({
  required String friendStatus,
  void Function()? onConnect,
  void Function()? onConfirm,
  void Function()? onDelete,
  void Function()? onCancelRequest,
  void Function()? onFollowing,
}) {
  Map<String, dynamic> friendStatusMap = {
    "is_friend": "Bạn bè",
    "sent_request": "Hủy yêu cầu",
    "received_request": "Phản hồi",
    "default": "Kết nối",
    "followed": "Đang theo dõi"
  };
  Map<String, dynamic> connectCallBack = {
    "is_friend": onDelete,
    "sent_request": onCancelRequest,
    "received_request": onConfirm,
    "default": onConnect,
    "followed": onFollowing
  };
  return Expanded(
    child: Visibility(
      visible: friendStatus != "is_friend",
      replacement: button(
          title: friendStatusMap[friendStatus],
          titleColor: Colors.black,
          buttonColor: Colors.transparent,
          onTap: onDelete),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: connectCallBack[friendStatus],
        child: Text(friendStatusMap[friendStatus],
            style: const TextStyle(color: Colors.white)),
      ),
    ),
  );
}

Widget button(
    {required String title,
    required Color titleColor,
    required Color buttonColor,
    void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        title,
        style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
