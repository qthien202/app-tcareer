import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

Widget pinPutWidget({TextEditingController? controller}) {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xffE1E1E1)),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(12),
    ),
  );
  return Pinput(
    autofocus: true,
    length: 6,
    controller: controller ?? TextEditingController(),
    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: focusedPinTheme,
    validator: (value) {
      if (value?.isEmpty == true) {
        return "Vui lòng nhập mã OTP";
      }
      if ((value?.length ?? 0) < 6) {
        return "Nhập đủ mã OTP";
      }
      return null;
    },
  );
}
