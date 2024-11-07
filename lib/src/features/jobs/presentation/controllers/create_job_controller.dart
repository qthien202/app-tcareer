import 'dart:convert';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/usecases/create_job_use_case.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
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
              initialChildSize: .65,
              maxChildSize: .95,
              minChildSize: .65,
              builder: (context, scrollController) {
                return builder(scrollController);
              },
            )).whenComplete(
      () {},
    );
  }

  Future<void> showBottomSheet(
      {required BuildContext context, required Widget child}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.grey.shade50,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: child,
        );
      },
    );
  }

  String? selectedJobTypeWorkSpace;
  String? selectedJobEmploymentType;
  List<Province> provinces = [];
  Future<void> getProvince() async {
    if (provinces.isEmpty) {
      provinces = await createJobUseCase.getProvince();
      notifyListeners();
    }
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
    addressType = AddressType.ward;
    selectedProvince = province;
    selectedDistrict = null;
    selectedWard = null;
    addressType = AddressType.district;
    notifyListeners();
    await getDistrict(selectedProvince?.provinceID ?? 0);
  }

  District? selectedDistrict;
  Future<void> selectDistrict(District district) async {
    addressType = AddressType.ward;
    selectedDistrict = district;
    selectedWard = null;
    notifyListeners();
    await getWard(selectedDistrict?.districtID ?? 0);
  }

  Ward? selectedWard;
  Future<void> selectWard(Ward ward) async {
    addressType = AddressType.fullAddress;
    selectedWard = ward;

    notifyListeners();
  }

  AddressType addressType = AddressType.fullAddress;
  // unSelectDistrict(){
  //    selectedDistrict =null;
  //    notifyListeners();
  //  }
  //
  //  unSelectDistrict(){
  //    selectedDistrict =null;
  //    notifyListeners();
  //  }

  resetAddress() {
    addressType = AddressType.fullAddress;
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    notifyListeners();
  }

  JobModel body = JobModel();
  void setJob({required JobModel job}) {
    body = job;
  }

  bool isLoading = false;

  void setIsLoading(bool value) {
    isLoading = value;

    notifyListeners();
  }

  Future<void> postCreateJob(BuildContext context) async {
    AppUtils.loadingApi(() async {
      await createJobUseCase.postCreateJob(body: body);
    }, context);
  }
}

final createJobControllerProvider = ChangeNotifierProvider((ref) {
  final createJobUseCase = ref.read(createJobUseCaseProvider);
  return CreateJobController(createJobUseCase);
});
