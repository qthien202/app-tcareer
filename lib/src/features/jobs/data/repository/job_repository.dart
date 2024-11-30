import 'dart:io';

import 'package:app_tcareer/src/features/jobs/data/models/add_job_topic_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/applicant_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/apply_job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_search_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/topic_job_favorite_response.dart';
import 'package:app_tcareer/src/services/address/address_services.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/apis/api_services.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/applicant_model.dart';
import '../models/job_topic_model.dart';

class JobRepository {
  final AddressServices addressServices;
  final ApiServices apiServices;
  final FirebaseStorageService storageService;
  JobRepository(this.addressServices, this.apiServices, this.storageService);

  Future<List<Province>> getProvince() async =>
      await addressServices.getProvince();
  Future<List<District>> getDistrict(num provinceId) async =>
      await addressServices.getDistrict(provinceId);
  Future<List<Ward>> getWard(num districtId) async =>
      await addressServices.getWard(districtId);

  Future<void> postCreateJob({required JobModel body}) async =>
      await apiServices.postCreateJob(body: body);

  Future<void> putUpdateJob(
          {required JobModel body, required num jobId}) async =>
      await apiServices.putUpdateJob(body: body, jobId: jobId);

  Future<List<JobTopicModel>> getJobTopic() async =>
      await apiServices.getJobTopic();

  Future<List<JobRolesModel>> getJobRoles(num topicId) async =>
      await apiServices.getJobRoles(topicId: topicId);

  Future<String> uploadFile(
      {required File file,
      required String folderPath,
      String? fileName,
      String contentType = "image/jpg"}) async {
    return await storageService.uploadFile(file, folderPath,
        contentType: contentType, fileName: fileName);
  }

  Future<void> postSubmitApplication(ApplyJobModel body) async =>
      await apiServices.postSubmitApplication(body: body);

  Future<GetJobResponse> getJobs({int? page, double? lat, double? lng}) async =>
      await apiServices.getJobs(page: page, lat: lat, lng: lng);

  Future<GetJobResponse> getPostedJob({int? page}) async =>
      await apiServices.getPostedJob(page: page);
  Future<GetJobResponse> getAppliedJob({int? page}) async =>
      await apiServices.getAppliedJob(page: page);

  Future<ApplicantResponse> getApplicants({required num jobId}) async =>
      await apiServices.getApplicants(jobId: jobId);

  Future<GetJobResponse> getJobFavorites({int? page}) async =>
      await apiServices.getJobFavorites(page: page);

  Future<void> postAddJobFavorite({required num jobId}) async =>
      await apiServices.postAddJobFavorite(jobId: jobId);

  Future<GetJobResponse> getSearchJob(
          {required JobSearchRequest query}) async =>
      await apiServices.getSearchJob(query: query);
  Future<void> postAddJobTopic({required AddJobTopicRequest body}) async =>
      await apiServices.postAddJobTopic(body: body);

  Future<TopicJobFavoriteResponse> getTopicJobFavorite() async =>
      await apiServices.getTopicJobFavorite();

  Future getApplicationDetail({required num applicationId}) async =>
      await apiServices.getApplicationDetail(applicationId: applicationId);
  Future getApplicationProfile({required num jobId}) async =>
      await apiServices.getApplicationProfile(jobId: jobId);

  Future getJobDetail({required num jobId}) async =>
      await apiServices.getJobDetail(jobId: jobId);

  Future deleteJob({required num jobId}) async =>
      await apiServices.deleteJob(jobId: jobId);
}

final jobRepositoryProvider = Provider((ref) {
  final addressServices = ref.read(addressServicesProvider);
  final apiServices = ref.read(apiServiceProvider);
  final firebaseStorageService = ref.read(firebaseStorageServiceProvider);
  return JobRepository(addressServices, apiServices, firebaseStorageService);
});
