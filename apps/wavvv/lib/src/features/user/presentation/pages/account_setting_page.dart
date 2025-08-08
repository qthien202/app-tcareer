import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountSettingPage extends ConsumerWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userControllerProvider);
    List<Map<String, dynamic>> settings = [
      {
        "onTap": () => context.pushNamed("editProfile"),
        "title": "Chỉnh sửa thông tin",
        "icon": PhosphorIconsRegular.userCircleGear
      },
      {
        "onTap": () => context.pushNamed("changePassword"),
        "title": "Đổi mật khẩu",
        "icon": PhosphorIconsRegular.lock
      },
      {
        "onTap": () => context.pushNamed("userJobTopic"),
        "title": "Lĩnh vực quan tâm",
        "icon": PhosphorIconsRegular.globe
      },
      {
        "onTap": () async => await controller.logout(context),
        "title": "Đăng xuất",
        "icon": PhosphorIconsRegular.signOut
      },
    ];
    List<Map<String, dynamic>> settingWithGoogle = [
      {
        "onTap": () => context.pushNamed("editProfile"),
        "title": "Chỉnh sửa thông tin",
        "icon": PhosphorIconsRegular.userCircleGear
      },
      {
        "onTap": () => context.pushNamed("userJobTopic"),
        "title": "Lĩnh vực quan tâm",
        "icon": PhosphorIconsRegular.globe
      },
      {
        "onTap": () async => await controller.logout(context),
        "title": "Đăng xuất",
        "icon": PhosphorIconsRegular.signOut
      },
    ];
    final settingData = controller.userData?.data?.isLoginGoogle == false
        ? settings
        : settingWithGoogle;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          "Thiết lập tài khoản",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: settingData.map((e) {
                return InkWell(
                  onTap: e['onTap'],
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: ScreenUtil().screenWidth,
                    child: Row(
                      children: [
                        PhosphorIcon(
                          e['icon'],
                          color: e['title'] == "Đăng xuất"
                              ? Colors.red
                              : Colors.black,
                          size: 28,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          e['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: e['title'] == "Đăng xuất"
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
