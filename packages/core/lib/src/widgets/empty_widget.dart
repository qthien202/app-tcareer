import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget emptyWidget(String content) {
  return Center(
    child: SizedBox(
      height: ScreenUtil().screenHeight * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/posts/empty.png",
            height: 30,
            width: 30,
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 10, color: Colors.black38),
          )
        ],
      ),
    ),
  );
}
