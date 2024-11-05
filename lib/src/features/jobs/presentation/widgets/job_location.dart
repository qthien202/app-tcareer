import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLocation extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const JobLocation({super.key, required this.scrollController});

  @override
  ConsumerState<JobLocation> createState() => _JobLocationState();
}

class _JobLocationState extends ConsumerState<JobLocation> {
  final FocusNode fullAddressFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(createJobControllerProvider);
      await controller.getProvince();
    });
  }

  @override
  void dispose() {
    fullAddressFocusNode.dispose(); // Hủy listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(createJobControllerProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 30,
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 4,
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Visibility(
                  visible: controller.addressType == AddressType.fullAddress,
                  replacement: addressSelected(),
                  child: Expanded(child: addressSelected())),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: controller.addressType != AddressType.fullAddress,
                child: Expanded(
                  child: CustomScrollView(
                    controller: widget.scrollController,
                    slivers: [sliverAppBar(), sliverAddress()],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget sliverAppBar() {
    final controller = ref.watch(createJobControllerProvider);
    String titleAppBar = controller.addressType == AddressType.ward
        ? "Phường/Xã"
        : controller.addressType == AddressType.district
            ? "Quận/Huyện"
            : "Tỉnh/Thành phố";

    return SliverAppBar(
      backgroundColor: Colors.grey.shade100,
      leading: null,
      toolbarHeight: 30,
      automaticallyImplyLeading: false,
      title: Text(
        titleAppBar,
        style: TextStyle(color: Colors.black45),
      ),
      pinned: true,
      centerTitle: false,
    );
  }

  Widget sliverAddress() {
    final controller = ref.watch(createJobControllerProvider);

    if (controller.addressType == AddressType.ward) {
      return sliverWard();
    } else if (controller.addressType == AddressType.district) {
      return sliverDistrict();
    }
    return sliverProvince();
  }

  Widget sliverProvince() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.provinces.length,
        (context, index) {
          final province = controller.provinces[index];
          bool isLastIndex = controller.provinces.length - index == 1;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async => await controller.selectProvince(province),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(province.provinceName ?? ""),
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sliverDistrict() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.districts.length,
        (context, index) {
          final district = controller.districts[index];
          bool isLastIndex = controller.districts.length - index == 1;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async => await controller.selectDistrict(district),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(district.districtName ?? ""),
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sliverWard() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: controller.wards.length,
        (context, index) {
          final ward = controller.wards[index];
          bool isLastIndex = controller.wards.length - index == 1;
          return Padding(
            padding: const EdgeInsets.only(left: 30),
            child: GestureDetector(
              onTap: () async => await controller.selectWard(ward),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(ward.wardName ?? ""),
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addressSelected() {
    final controller = ref.watch(createJobControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        controller: controller.addressType == AddressType.fullAddress
            ? widget.scrollController
            : null,
        physics: controller.addressType == AddressType.fullAddress
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Địa điểm làm việc",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: controller.selectedProvince != null,
                  child: TextButton(
                      onPressed: () => controller.resetAddress(),
                      child: Text(
                        "Thiết lập lại",
                        style: TextStyle(color: AppColors.primary),
                      )),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.addressType = AddressType.province;
                });
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: ScreenUtil().screenWidth,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: controller.addressType == AddressType.province
                              ? AppColors.primary
                              : Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tỉnh/Thành phố",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.selectedProvince?.provinceName ??
                            "Nhấn vào để chọn",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: controller.selectedProvince != null
                  ? () {
                      setState(() {
                        controller.addressType = AddressType.district;
                      });
                    }
                  : null,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: ScreenUtil().screenWidth,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: controller.addressType == AddressType.district
                              ? AppColors.primary
                              : Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quận/Huyện",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.selectedDistrict?.districtName ??
                            "Nhấn vào để chọn",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ),
            GestureDetector(
              onTap: controller.selectedDistrict != null
                  ? () {
                      setState(() {
                        controller.addressType = AddressType.ward;
                      });
                    }
                  : null,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: ScreenUtil().screenWidth,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: controller.addressType == AddressType.ward
                              ? AppColors.primary
                              : Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phường/Xã",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.selectedWard?.wardName ?? "Nhấn vào để chọn",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ),
            Visibility(
              visible: controller.addressType == AddressType.fullAddress,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: ScreenUtil().screenWidth,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: controller.addressType == AddressType.province
                              ? AppColors.primary
                              : Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tên đường, Tòa nhà, Số nhà.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      fullAddress()
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: controller.addressType == AddressType.fullAddress,
              child: SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget fullAddress(
      {int? minLines,
      TextEditingController? controller,
      int? maxLines,
      String? hintText,
      void Function(String)? onChanged}) {
    return SizedBox(
      height: 35,
      child: TextField(
        focusNode: fullAddressFocusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        autofocus: false,
        // minLines: minLines,
        onTap: () {},
        maxLines: maxLines,
        controller: controller,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        // Gán focusNode vào TextField
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            // hintText: hintText ?? "Hôm nay bạn muốn chia sẻ điều gì?",
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }
}
