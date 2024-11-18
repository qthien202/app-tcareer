import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/applicant_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  ScrollController jobFavoriteScrollController = ScrollController();
  int jobPage = 1;
  int postedPage = 1;
  int appliedPage = 1;
  List<JobModel> jobs = [];
  GetJobResponse? jobResponse;
  Future<void> getJobs() async {
    if (currentPosition != null) {
      jobResponse = await jobUseCase.getJobs(
          page: jobPage,
          lat: currentPosition?.latitude,
          lng: currentPosition?.longitude);
    } else {
      jobResponse = await jobUseCase.getJobs(
        page: jobPage,
      );
    }
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

  Future<void> loadJobFavoriteMore() async {
    if (jobFavoriteScrollController.position.maxScrollExtent ==
        jobFavoriteScrollController.offset) {
      if (jobFavorites.length < (jobFavoriteRes?.meta?.total ?? 0)) {
        favoritePage += 1;
        await getJobFavorites();
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

  List<JobModel> jobFavorites = [];
  GetJobResponse? jobFavoriteRes;
  int favoritePage = 1;
  Future<void> getJobFavorites() async {
    jobFavoriteRes = await jobUseCase.getJobFavorites(page: favoritePage);
    if (jobFavoriteRes?.data != null) {
      final newJobs = jobFavoriteRes?.data
          ?.where((newJob) => !jobFavorites.any((job) => job.id == newJob.id))
          .toList();
      jobFavorites.addAll(newJobs as Iterable<JobModel>);
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
    if (currentPosition != null) {
      await getCurrentPosition();
    }
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

  Future<void> refreshJobFavorites() async {
    jobFavoriteRes = null;
    jobFavorites.clear();
    favoritePage = 1;
    await getJobFavorites();
  }

  bool isFavorite = false;

  Future<void> postAddJobFavorite(
      {required num jobId,
      required BuildContext context,
      required JobType type}) async {
    AppUtils.loadingApi(() async {
      await jobUseCase.postAddJobFavorite(jobId: jobId);
      // print(">>>>>>>>>isFavorite1: $isJobFavorite");
      if (isFavorite == true) {
        isFavorite = false;
        showSnackBar("Đã bỏ lưu việc làm");
      } else {
        isFavorite = true;
        showSnackBar("Lưu việc làm thành công");
      }
      await handleUpdateJob(type);
      notifyListeners();
    }, context);
  }

  Future<void> handleUpdateJob(JobType type) async {
    if (type == JobType.favorite) {
      await refreshJobFavorites();
    }
    if (type == JobType.postedJob) {
      await refreshPostedJob();
    }
    if (type == JobType.applied) {
      await refreshAppliedJob();
    } else {
      jobs.clear();
      await refreshJob();
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Position? currentPosition;
  Future<void> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("GPS chưa bật. Vui lòng bật GPS để tiếp tục.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Quyền truy cập vị trí bị từ chối.");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Quyền truy cập vị trí bị từ chối vĩnh viễn.");
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (currentPosition != null) {
      await getAddressFromLatLng(
          lat: currentPosition?.latitude ?? 0,
          lng: currentPosition?.longitude ?? 0);
    }
  }

  String? currentLocation;
  Future<void> getAddressFromLatLng(
      {required double lat, required double lng}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    print(">>>>>>>>>>>>place: ${placemarks.first.administrativeArea}");
    String province = placemarks.first.administrativeArea ?? "";
    String district = placemarks.first.subAdministrativeArea ?? "";
    currentLocation = "$district, $province";
    notifyListeners();
  }
}

final jobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return JobController(jobUseCase);
});
