import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDialogUtil {
  static AlertDialog alertDialog(
      {required BuildContext context,
      required String title,
      required String content}) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // icon: Icon(
      //   Icons.error,
      //   color: Colors.red,
      //   size: 40,
      // ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            "Thoát",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  static Future<void> showAlert(
      {required BuildContext context,
      required String title,
      required String content}) async {
    await showDialog(
      context: context,
      builder: (context) =>
          alertDialog(context: context, title: title, content: content),
    );
  }

  static Future<bool?> showConfirmDialog(
      {required BuildContext context,
      required String message,
      void Function()? onCancel,
      void Function()? onConfirm,
      String? confirmTitle}) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.white,
        title: const Text("Thông báo"),
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, letterSpacing: 0.5, height: 1.2),
        ),
        // content: Text(message),
        actions: <Widget>[
          TextButton(
              onPressed: onCancel ??
                  () {
                    context.pop();
                  },
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 14, color: Colors.red),
              )),
          TextButton(
              onPressed: onConfirm,
              child: Text(
                confirmTitle ?? "Tiếp tục",
                style: TextStyle(fontSize: 14, color: AppColors.primary),
              )),
        ],
      ),
    );
  }
}
