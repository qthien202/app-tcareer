import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                width: 30,
                height: 4,
              ),
              const SizedBox(height: 10),
              // const Text(
              //   "Bình luận",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bạn muốn thêm gì?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                textAlign: TextAlign.center,
                "Bạn có muốn đăng các mẹo và kinh nghiệm của mình hoặc đăng tin tuyển dụng?",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 50,
                width: ScreenUtil().screenWidth,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: () {
                      context.pop();
                      context.pushNamed('posting');
                    },
                    child: Text(
                      "Tạo bài viết",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: ScreenUtil().screenWidth,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      context.pop();
                      context.pushNamed('createJob');
                    },
                    child: Text(
                      "Đăng tin tuyển dụng",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
