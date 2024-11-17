import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_search_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/search/search_experience.dart';
import 'package:app_tcareer/src/features/jobs/usecases/create_job_use_case.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SearchJobController extends ChangeNotifier {
  JobUseCase jobUseCase;
  CreateJobUseCase createJobUseCase;
  SearchJobController(this.jobUseCase, this.createJobUseCase);
  final Debouncer deBouncer = Debouncer(milliseconds: 1000);
  GetJobResponse? jobRes;
  List<JobModel> jobs = [];
  TextEditingController queryController = TextEditingController();

  JobSearchRequest searchRequest = JobSearchRequest();

  Future<void> setJobSearchRequest({
    String? q,
    List<String>? experienceRequired,
    List<String>? jobTopicId,
    List<String>? jobType,
    List<String>? province,
    List<String>? employmentType,
  }) async {
    searchRequest = searchRequest.copyWith(
        q: q,
        experienceRequired: experienceRequired,
        employmentType: employmentType,
        jobTopicId: jobTopicId,
        jobType: jobType,
        province: province);
  }

  Future<void> getSearchJob() async {
    jobRes = await jobUseCase.getSearchJob(query: searchRequest);
    if (jobRes?.data != null) {
      final newJobs = jobRes?.data
          ?.where((newJob) => !jobs.any((job) => job.id == newJob.id))
          .toList();
      jobs.addAll(newJobs as Iterable<JobModel>);
      print(">>>>>>>>>>jobs: $jobs");
      notifyListeners();
    }
  }

  Future<void> onSearch() async {
    deBouncer.run(() async {
      jobRes = null;
      jobs.clear();
      await setJobSearchRequest(q: queryController.text);
      await getSearchJob();
    });
  }

  bool isLoading = false;
  setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  List<Province> provinces = [];

  Future<void> getProvince() async {
    if (provinces.isEmpty) {
      provinces = await createJobUseCase.getProvince();
      notifyListeners();
    }
  }

  List<JobTopicModel> jobTopic = [];
  Future<void> getJobTopic() async {
    jobTopic.clear();
    jobTopic = await jobUseCase.getJobTopic();
    notifyListeners();
  }

  Future<void> showCupertinoModalPicker(
    BuildContext context,
  ) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return const SearchExperience();
      },
    );
  }

  Future<void> refreshSearchJob() async {
    jobRes = null;
    jobs.clear();
    await getSearchJob();
  }

  Future<void> showBottomSheet(
      {required BuildContext context, required Widget child}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: ScreenUtil().screenHeight * .6),
              child: child),
        );
      },
    );
  }

  List<String> selectedProvinces = [];
  Future<void> selectProvince(
      {required bool isSelected, required String value}) async {
    isSelected ? selectedProvinces.add(value) : selectedProvinces.remove(value);
    notifyListeners();
  }

  List<String> selectedJobTopics = [];
  Future<void> selectJobTopic(
      {required bool isSelected, required String value}) async {
    isSelected ? selectedJobTopics.add(value) : selectedJobTopics.remove(value);
    notifyListeners();
  }

  Future<void> searchFromAddress() async {
    await setJobSearchRequest(province: selectedProvinces);
    await refreshSearchJob();
  }

  Future<void> searchFromJobTopic() async {
    await setJobSearchRequest(jobTopicId: selectedJobTopics);
    await refreshSearchJob();
  }

  clearProvince() {
    selectedProvinces.clear();
    notifyListeners();
  }
}

final searchJobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  final createJobUseCase = ref.read(createJobUseCaseProvider);
  return SearchJobController(jobUseCase, createJobUseCase);
});
