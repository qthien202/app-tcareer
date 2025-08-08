import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@override
Widget circularLoadingWidget() {
  return const Center(
      child: SizedBox(
    width: 20.0,
    height: 20.0,
    child: CupertinoActivityIndicator(color: Colors.grey, radius: 10),
  ));
}
