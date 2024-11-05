import 'dart:convert';
import 'package:app_tcareer/src/features/jobs/usecases/create_job_use_case.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddressType { province, district, ward, fullAddress }

class CreateJobController extends ChangeNotifier {
  final CreateJobUseCase createJobUseCase;
  CreateJobController(this.createJobUseCase);
  Future<void> showBottomSheetDraggable(
      {required BuildContext context,
      required Widget Function(ScrollController scrollController)
          builder}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              snap: true,
              initialChildSize: .7,
              maxChildSize: .95,
              minChildSize: .7,
              builder: (context, scrollController) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Kiểm tra xem bàn phím có hiển thị không
                  if (MediaQuery.of(context).viewInsets.bottom > 0) {
                    // Cuộn đến cuối danh sách
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                });
                return builder(scrollController);
              },
            )).whenComplete(
      () {},
    );
  }

  Future<void> showBottomSheet(
      {required BuildContext context, required Widget child}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return child;
      },
    );
  }

  String? selectedJobTypeWorkSpace;
  List<Province> provinces = [];
  Future<void> getProvince() async {
    provinces = await createJobUseCase.getProvince();
    notifyListeners();
  }

  List<District> districts = [];
  Future<void> getDistrict(num provinceId) async {
    districts = await createJobUseCase.getDistrict(provinceId);
    notifyListeners();
  }

  List<Ward> wards = [];
  Future<void> getWard(num districtId) async {
    wards = await createJobUseCase.getWard(districtId);
    notifyListeners();
  }

  Province? selectedProvince;
  Future<void> selectProvince(Province province) async {
    selectedProvince = province;
    selectedDistrict = null;
    selectedWard = null;

    addressType = AddressType.district;
    notifyListeners();
    await getDistrict(selectedProvince?.provinceID ?? 0);
  }

  District? selectedDistrict;
  Future<void> selectDistrict(District district) async {
    selectedDistrict = district;
    selectedWard = null;

    addressType = AddressType.ward;
    notifyListeners();
    await getWard(selectedDistrict?.districtID ?? 0);
  }

  Ward? selectedWard;
  Future<void> selectWard(Ward ward) async {
    selectedWard = ward;
    addressType = AddressType.fullAddress;
    notifyListeners();
  }

  AddressType addressType = AddressType.province;
  // unSelectDistrict(){
  //    selectedDistrict =null;
  //    notifyListeners();
  //  }
  //
  //  unSelectDistrict(){
  //    selectedDistrict =null;
  //    notifyListeners();
  //  }
}

final createJobControllerProvider = ChangeNotifierProvider((ref) {
  final createJobUseCase = ref.read(createJobUseCaseProvider);
  return CreateJobController(createJobUseCase);
});
