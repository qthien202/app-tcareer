import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/applicant_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobController extends ChangeNotifier {
  final JobUseCase jobUseCase;
  JobController(this.jobUseCase) {
    jobScrollController.addListener(() {
      loadJobMore();
    });

    postedJobScrollController.addListener(() {
      loadPostedJobMore();
    });

    appliedJobScrollController.addListener(() {
      loadAppliedJobMore();
    });
  }
  ScrollController jobScrollController = ScrollController();
  ScrollController postedJobScrollController = ScrollController();
  ScrollController appliedJobScrollController = ScrollController();
  int jobPage = 1;
  int postedPage = 1;
  int appliedPage = 1;
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
    postedJobRes = await jobUseCase.getPostedJob(page: postedPage);
    if (postedJobRes?.data != null) {
      final newJobs = postedJobRes?.data
          ?.where((newJob) => !postedJobs.any((job) => job.id == newJob.id))
          .toList();
      postedJobs.addAll(newJobs as Iterable<JobModel>);
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

  Future<void> loadPostedJobMore() async {
    if (postedJobScrollController.position.maxScrollExtent ==
        postedJobScrollController.offset) {
      if (postedJobs.length < (postedJobRes?.meta?.total ?? 0)) {
        postedPage += 1;
        await getPostedJob();
      }
    }
  }

  Future<void> loadAppliedJobMore() async {
    if (appliedJobScrollController.position.maxScrollExtent ==
        appliedJobScrollController.offset) {
      if (appliedJobs.length < (appliedJobRes?.meta?.total ?? 0)) {
        appliedPage += 1;
        await getAppliedJob();
      }
    }
  }

  List<JobModel> appliedJobs = [];
  GetJobResponse? appliedJobRes;
  Future<void> getAppliedJob() async {
    appliedJobRes = await jobUseCase.getAppliedJob(page: appliedPage);
    if (appliedJobRes?.data != null) {
      final newJobs = appliedJobRes?.data
          ?.where((newJob) => !appliedJobs.any((job) => job.id == newJob.id))
          .toList();
      appliedJobs.addAll(newJobs as Iterable<JobModel>);
      notifyListeners();
    }
  }

  ApplicantResponse? applicantResponse;
  List<ApplicantModel> applicants = [];
  Future<void> getApplicants(num jobId) async {
    applicantResponse = await jobUseCase.getApplicants(jobId: jobId);
    if (applicantResponse?.data != null) {
      final newApplicants = applicantResponse?.data
          ?.where((newApplicant) =>
              !applicants.any((applicant) => applicant.id == newApplicant.id))
          .toList();
      applicants.addAll(newApplicants as Iterable<ApplicantModel>);
    }
    notifyListeners();
  }

  Future<void> refreshJob() async {
    jobResponse = null;
    jobs.clear();
    jobPage = 1;
    await getJobs();
  }

  Future<void> refreshPostedJob() async {
    postedJobRes = null;
    postedJobs.clear();
    postedPage = 1;
    await getPostedJob();
  }

  Future<void> refreshAppliedJob() async {
    appliedJobRes = null;
    appliedJobs.clear();
    appliedPage = 1;
    await getAppliedJob();
  }

  Future<void> refreshApplicant(num jobId) async {
    applicantResponse = null;
    applicants.clear();
    await getApplicants(jobId);
  }

  Future<void> resetApplicants() async {
    applicantResponse = null;
    applicants.clear();
  }

  Future<void> postAddJobFavorite(
      {required num jobId, required BuildContext context}) async {
    AppUtils.loadingApi(() async {
      await jobUseCase.postAddJobFavorite(jobId: jobId);
      showSnackBar("Lưu việc làm thành công");
    }, context);
  }
}

final jobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return JobController(jobUseCase);
});
