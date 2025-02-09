import 'dart:convert';
import 'dart:io';
import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_location_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_employee_qty.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_experience.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_location.dart';
import 'package:app_tcareer/src/features/jobs/domain/create_job_use_case.dart';
import 'package:app_tcareer/src/features/jobs/domain/job_use_case.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:uuid/uuid.dart';

enum AddressType { province, district, ward, fullAddress }

enum JobOption { jobTopic, jobRole, none }

class CreateJobController extends ChangeNotifier {
  final CreateJobUseCase createJobUseCase;
  final JobUseCase jobUseCase;
  final JobController jobController;

  CreateJobController(
      this.createJobUseCase, this.jobUseCase, this.jobController);

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
        wardId: selectedWard?.wardCode, wardName: selectedWard?.wardName);
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
      JobLocationModel? detailLocation,
      num? latitude,
      num? longitude,
      String? employmentType,
      String? experienceName,
      String? ctyName,
      String? ctyImageUrl,
      num? experienceRequired,
      num? positionsAvailable,
      String? expiredDate}) async {
    job = job.copyWith(
        title: title,
        jobTopicId: jobTopicId,
        jobType: jobType,
        jobDescription: jobDescription,
        detailLocation: detailLocation,
        province: detailLocation?.provinceName,
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
        positionsAvailable: positionsAvailable,
        expiredDate: expiredDate);

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

  Future<void> showEmployeeQtyPicker(
    BuildContext context,
  ) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return const JobEmployeeQty();
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
    String? wardId,
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

  Future<void> setDescription() async {
    if (job.jobDescription != null) {
      await quillController.setText(job.jobDescription ?? "");
      notifyListeners();
    }
  }

  bool validateJobModel() {
    return job.title != null &&
        job.jobTopicId != null &&
        job.jobTopicName != null &&
        job.jobRoleId != null &&
        job.jobRoleName != null &&
        job.jobType != null &&
        job.jobDescription != null &&
        job.detailLocation != null &&
        job.latitude != null &&
        job.longitude != null &&
        job.employmentType != null &&
        job.experienceName != null &&
        job.ctyName != null &&
        job.ctyImageUrl != null &&
        job.experienceRequired != null &&
        job.positionsAvailable != null;
  }

  Future<void> saveJobDescription(BuildContext context) async {
    final description = await quillController.getText();
    await setJob(jobDescription: description);
    context.pop();
  }

  bool isHtmlValid = false;
  Future<void> setIsHtmlValid(bool value) async {
    isHtmlValid = value;
    notifyListeners();
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

  clearData() {
    selectedExpiredDate = "";
    selectedJobTopic = null;
    selectedJobRole = null;
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    selectedJobEmploymentType = null;
    selectedJobTypeWorkSpace = null;
    addressController.clear();
  }

  Future<void> postCreateJob(BuildContext context) async {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputFormat = DateFormat("yyyy/MM/dd");
    DateTime dateTime = inputFormat.parse(job.expiredDate ?? "");
    String outputDate = outputFormat.format(dateTime);
    job = job.copyWith(expiredDate: outputDate);
    AppUtils.loadingApi(() async {
      await uploadImage();

      await createJobUseCase.postCreateJob(body: job);
      job.reset();
      clearData();
      showSnackBar("Thêm công việc thành công");
      if (context.mounted) {
        context.goNamed("jobs");
      }
    }, context);
  }

  Future<void> putUpdateJob({
    required BuildContext context,
    required num jobId,
  }) async {
    try {
      await AppUtils.loadingApi(() async {
        if (job.ctyImageUrl?.isImageNetWork == false) {
          await uploadImage();
        }
        await createJobUseCase.putUpdateJob(body: job, jobId: jobId);
        job.reset();
        clearData();
        showSnackBar("Cập nhật công việc thành công");
        if (context.mounted) {
          context.pushReplacementNamed("jobDetail",
              pathParameters: {"id": jobId.toString()},
              extra: {"type": JobType.postedJob});
        }
      }, context);
    } catch (e) {
      showSnackBar("Có lỗi xảy ra: ${e.toString()}");
    }
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

  Future<void> showExpiredDatePicker({
    required BuildContext context,
  }) async {
    DateTime initialDate = job.expiredDate != null
        ? DateFormat('dd/MM/yyyy').parse(job.expiredDate ?? "")
        : DateTime.now();
    await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // height: 40,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chọn hạn nộp hồ sơ',
                          style: TextStyle(
                              letterSpacing: 0,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () async {
                            await setJob(expiredDate: selectedExpiredDate);
                            if (selectedExpiredDate == null) {
                              await selectExpiredDate(value: DateTime.now());
                              await setJob(expiredDate: selectedExpiredDate);
                            }
                            context.pop();
                          },
                          child: const Text(
                            'Xong',
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day),
                    maximumDate: DateTime(2101),
                    onDateTimeChanged: (pickedDate) async {
                      await selectExpiredDate(value: pickedDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? selectedExpiredDate;
  Future<void> selectExpiredDate({required DateTime value}) async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(value);
    selectedExpiredDate = formattedDate;

    notifyListeners();
  }

  TextEditingController addressController = TextEditingController();

  String getAddressBeforeKeywords(String input) {
    // Các từ khóa để kiểm tra
    List<String> keywords = ["Phường", "Quận", "Thành phố"];

    // Tìm vị trí của từ khóa đầu tiên xuất hiện
    int index = input.indexOf(RegExp(r'Phường|Quận|Thành phố'));

    // Lấy phần chuỗi trước từ khóa (nếu từ khóa tồn tại)
    String result = index != -1 ? input.substring(0, index).trim() : input;

    // Xóa dấu phẩy cuối cùng (nếu có)
    if (result.endsWith(",")) {
      result = result.substring(0, result.length - 1).trim();
    }

    return result;
  }
}

final createJobControllerProvider = ChangeNotifierProvider((ref) {
  final createJobUseCase = ref.read(createJobUseCaseProvider);
  final jobUseCase = ref.read(jobUseCaseProvider);
  final jobController = ref.read(jobControllerProvider);
  return CreateJobController(createJobUseCase, jobUseCase, jobController);
});
