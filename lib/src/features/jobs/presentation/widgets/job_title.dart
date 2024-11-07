import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/authentication/presentation/widgets/text_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobTitle extends StatelessWidget {
  const JobTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Wrap(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              width: 30,
              height: 4,
            ),
          ),
          TextInputForm(
            title: "Tiêu đề",
            hintText: "Nhập tiêu đề",
            maxLine: 3,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            width: ScreenUtil().screenWidth,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: Text(
                  "Hoàn thành",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
