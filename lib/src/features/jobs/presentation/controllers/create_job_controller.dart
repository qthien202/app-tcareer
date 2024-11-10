import 'dart:convert';
import 'dart:io';
import 'package:app_tcareer/src/features/jobs/data/models/job_location_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_experience.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_location.dart';
import 'package:app_tcareer/src/features/jobs/usecases/create_job_use_case.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:uuid/uuid.dart';

enum AddressType { province, district, ward, fullAddress }

enum JobOption { jobTopic, jobRole, none }

class CreateJobController extends ChangeNotifier {
  final CreateJobUseCase createJobUseCase;
  final JobUseCase jobUseCase;

  CreateJobController(this.createJobUseCase, this.jobUseCase);

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
    await setJobLocation(
        provinceId: selectedProvince?.provinceID,
        provinceName: selectedProvince?.provinceName);
    notifyListeners();
    await getDistrict(selectedProvince?.provinceID ?? 0);
  }

  District? selectedDistrict;

  Future<void> selectDistrict(District district) async {
    addressType = AddressType.ward;
    selectedDistrict = district;
    selectedWard = null;
    await setJobLocation(
        districtId: selectedDistrict?.districtID,
        districtName: selectedDistrict?.districtName);
    notifyListeners();
    await getWard(selectedDistrict?.districtID ?? 0);
  }

  Ward? selectedWard;

  Future<void> selectWard(Ward ward) async {
    addressType = AddressType.fullAddress;
    selectedWard = ward;
    await setJobLocation(
        wardId: num.parse(selectedWard?.wardCode ?? ""),
        wardName: selectedWard?.wardName);
    notifyListeners();
  }

  AddressType addressType = AddressType.fullAddress;

  resetAddress() {
    addressType = AddressType.fullAddress;
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    notifyListeners();
  }

  JobModel job = JobModel();

  Future<void> setJob(
      {String? title,
      num? jobTopicId,
      String? jobTopicName,
      num? jobRoleId,
      String? jobRoleName,
      String? jobType,
      String? jobDescription,
      dynamic detailLocation,
      num? latitude,
      num? longitude,
      String? employmentType,
      String? experienceName,
      String? ctyName,
      String? ctyImageUrl,
      num? experienceRequired,
      num? positionsAvailable}) async {
    job = job.copyWith(
        title: title,
        jobTopicId: jobTopicId,
        jobType: jobType,
        jobDescription: jobDescription,
        detailLocation: detailLocation,
        latitude: latitude,
        longitude: longitude,
        experienceRequired: experienceRequired,
        ctyImageUrl: ctyImageUrl,
        ctyName: ctyName,
        employmentType: employmentType,
        jobTopicName: jobTopicName,
        jobRoleId: jobRoleId,
        jobRoleName: jobRoleName,
        experienceName: experienceName,
        positionsAvailable: positionsAvailable);
    print(">>>>>>>>>>body: ${jsonEncode(job)}");
    notifyListeners();
  }

  bool isLoading = false;

  void setIsLoading(bool value) {
    isLoading = value;

    notifyListeners();
  }

  List<Location>? locations;

  Future<void> getLatLngFromAddress({required String fullAddress}) async {
    locations = await locationFromAddress(fullAddress);
  }

  Future<void> showExperiencePicker(
    BuildContext context,
  ) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return const JobExperience();
      },
    );
  }

  Future<void> selectJobType(String value) async {
    selectedJobTypeWorkSpace = value;
    await setJob(jobType: selectedJobTypeWorkSpace);
    notifyListeners();
  }

  Future<void> selectJobEmploymentType(String value) async {
    selectedJobEmploymentType = value;
    await setJob(employmentType: selectedJobEmploymentType);
    notifyListeners();
  }

  Map<String, dynamic> jobType = {
    "onsite": "On-site",
    "hybrid": "Hybrid",
    "remote": "Remote"
  };

  Map<String, dynamic> employmentType = {
    "full-time": "Full time",
    "part-time": "Part time",
    "contract": "Contract",
    "internship": "Internship"
  };

  String? getJobType(String value) {
    return jobType[value];
  }

  String? getEmploymentType(String value) {
    return employmentType[value];
  }

  JobLocationModel jobLocation = JobLocationModel();

  Future<void> setJobLocation({
    num? provinceId,
    String? provinceName,
    num? districtId,
    String? districtName,
    num? wardId,
    String? wardName,
    String? fullAddress,
  }) async {
    jobLocation = jobLocation.copyWith(
        provinceName: provinceName,
        districtName: districtName,
        wardName: wardName,
        provinceId: provinceId,
        districtId: districtId,
        wardId: wardId,
        fullAddress: fullAddress,
        latitude: locations?.first.latitude,
        longitude: locations?.first.longitude);
    await setJob(
        detailLocation: jobLocation,
        latitude: locations?.first.latitude,
        longitude: locations?.first.longitude);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final QuillEditorController quillController = QuillEditorController();

  Future<void> saveJobDescription(BuildContext context) async {
    final description = await quillController.getText();
    await setJob(jobDescription: description);
    context.pop();
  }

  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    delegate.pasteText(SelectionChangedCause.toolbar);
  }

  List<JobTopicModel> jobTopic = [];
  Future<void> getJobTopic() async {
    jobTopic.clear();
    jobTopic = await jobUseCase.getJobTopic();
    notifyListeners();
  }

  List<JobRolesModel> jobRoles = [];
  Future<void> getJobRoles(num topicId) async {
    jobRoles.clear();
    jobRoles = await jobUseCase.getJobRoles(topicId);
    notifyListeners();
  }

  JobTopicModel? selectedJobTopic;
  JobOption jobOption = JobOption.jobTopic;
  Future<void> selectJobTopic(JobTopicModel value) async {
    selectedJobTopic = value;
    jobOption = JobOption.jobRole;
    notifyListeners();
    await getJobRoles(selectedJobTopic?.id ?? 0);
  }

  JobRolesModel? selectedJobRole;
  Future<void> selectJobRole(JobRolesModel value) async {
    selectedJobRole = value;
    jobOption = JobOption.none;
    notifyListeners();
  }

  JobModel? body;
  Future<void> postCreateJob(BuildContext context) async {
    AppUtils.loadingApi(() async {
      await uploadImage();
      body = job;
      await createJobUseCase.postCreateJob(body: body!);
    }, context);
  }

  Future<void> uploadImage() async {
    const uuid = Uuid();
    final id = uuid.v4();
    String? imageUrl = await createJobUseCase.uploadImage(
        file: File(job.ctyImageUrl ?? ""), folderPath: "jobs/$id");
    if (imageUrl != "") {
      job = job.copyWith(ctyImageUrl: imageUrl);
    }
  }
}

final createJobControllerProvider = ChangeNotifierProvider((ref) {
  final createJobUseCase = ref.read(createJobUseCaseProvider);
  final jobUseCase = ref.read(jobUseCaseProvider);
  return CreateJobController(createJobUseCase, jobUseCase);
});
