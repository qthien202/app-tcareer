import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobController extends ChangeNotifier {
  final JobUseCase jobUseCase;
  JobController(this.jobUseCase) {
    jobScrollController.addListener(() {});
  }
  ScrollController jobScrollController = ScrollController();
  int jobPage = 1;
  List<JobModel> jobs = [];
  GetJobResponse? jobResponse;
  Future<void> getJobs() async {
    jobs.clear();
    jobResponse = await jobUseCase.getJobs();
    if (jobResponse != null) {
      jobs.addAll(jobResponse?.data as Iterable<JobModel>);
      notifyListeners();
    }
  }

  List<JobModel> postedJobs = [];
  GetJobResponse? postedJobRes;
  Future<void> getPostedJob() async {
    postedJobs.clear();
    postedJobRes = await jobUseCase.getPostedJob();
    if (postedJobRes != null) {
      postedJobs.addAll(postedJobRes?.data as Iterable<JobModel>);
      notifyListeners();
    }
  }

  List<JobModel> appliedJobs = [];
  GetJobResponse? appliedJobRes;
  Future<void> getAppliedJob() async {
    appliedJobs.clear();
    appliedJobRes = await jobUseCase.getAppliedJob();
    if (appliedJobRes != null) {
      appliedJobs.addAll(appliedJobRes?.data as Iterable<JobModel>);
      notifyListeners();
    }
  }
}

final jobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return JobController(jobUseCase);
});
