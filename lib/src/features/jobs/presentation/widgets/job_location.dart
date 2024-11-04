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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await ref.read(createJobControllerProvider).getProvince();
    });
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
          body: CustomScrollView(
            controller: widget.scrollController,
            slivers: [sliverSelected(), sliverAppBar(), sliverAddress()],
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
            child: InkWell(
              onTap: () async => await controller.selectProvince(province),
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
            child: InkWell(
              onTap: () async => await controller.selectDistrict(district),
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
            child: InkWell(
              onTap: () async => await controller.selectWard(ward),
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
          );
        },
      ),
    );
  }

  Widget sliverSelected() {
    final controller = ref.watch(createJobControllerProvider);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: controller.selectedProvince != null,
                child: Text(
                  "Khu vực được chọn",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Visibility(
              visible: controller.selectedProvince != null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      controller.addressType = AddressType.province;
                    });
                  },
                  title: Text("Tỉnh/Thành phố"),
                  subtitle:
                      Text(controller.selectedProvince?.provinceName ?? ""),
                ),
              ),
            ),
            Visibility(
              visible: controller.selectedDistrict != null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      controller.addressType = AddressType.district;
                    });
                  },
                  title: Text("Quận Huyện"),
                  subtitle:
                      Text(controller.selectedDistrict?.districtName ?? ""),
                ),
              ),
            ),
            Visibility(
              visible: controller.selectedWard != null,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      controller.addressType = AddressType.ward;
                    });
                  },
                  title: Text("Phường/Xã"),
                  subtitle: Text(controller.selectedWard?.wardName ?? ""),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
