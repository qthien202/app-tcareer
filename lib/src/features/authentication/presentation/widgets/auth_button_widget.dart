import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';

Widget authButtonWidget(
    {required BuildContext context,
    required void Function()? onPressed,
    required String title}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: AppColors.authButton),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.84),
        )),
  );
}

Widget authOtherButton(
    {required BuildContext context,
    required void Function()? onPressed,
    required String title}) {
  return SizedBox(
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade200),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            backgroundColor: Colors.white),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              // fontWeight: FontWeight.w400,
              letterSpacing: 0.84),
        )),
  );
}
