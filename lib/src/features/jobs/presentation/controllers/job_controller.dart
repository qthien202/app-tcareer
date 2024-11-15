import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobController extends ChangeNotifier {
  final JobUseCase jobUseCase;
  JobController(this.jobUseCase) {
    jobScrollController.addListener(() {
      loadJobMore();
    });
  }
  ScrollController jobScrollController = ScrollController();
  int jobPage = 1;
  List<JobModel> jobs = [];
  GetJobResponse? jobResponse;
  Future<void> getJobs() async {
    jobResponse = await jobUseCase.getJobs(page: jobPage);
    if (jobResponse?.data != null) {
      final newJobs = jobResponse?.data
          ?.where((newJob) => !jobs.any((job) => job.id == newJob.id))
          .toList();
      jobs.addAll(newJobs as Iterable<JobModel>);
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

  Future<void> loadJobMore() async {
    if (jobScrollController.position.maxScrollExtent ==
        jobScrollController.offset) {
      if (jobs.length < (jobResponse?.meta?.total ?? 0)) {
        jobPage += 1;
        await getJobs();
      }
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

  Future<void> refreshJob() async {
    jobResponse = null;
    jobs.clear();
    jobPage = 1;
    await getJobs();
  }
}

final jobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return JobController(jobUseCase);
});
