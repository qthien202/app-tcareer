import 'dart:io';

import 'package:app_tcareer/src/features/jobs/data/models/applicant_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/applicant_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_search_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/apply_job_model.dart';

class JobUseCase {
  final JobRepository jobRepository;
  JobUseCase(this.jobRepository);

  Future<List<JobTopicModel>> getJobTopic() async =>
      await jobRepository.getJobTopic();

  Future<List<JobRolesModel>> getJobRoles(num topicId) async =>
      await jobRepository.getJobRoles(topicId);

  Future<GetJobResponse> getJobs({int? page, double? lat, double? lng}) async =>
      await jobRepository.getJobs(page: page, lat: lat, lng: lng);
  Future<GetJobResponse> getPostedJob({int? page}) async =>
      await jobRepository.getPostedJob(page: page);
  Future<GetJobResponse> getAppliedJob({int? page}) async =>
      await jobRepository.getAppliedJob(page: page);
  Future<String> uploadFile(
          {required File file,
          required String folderPath,
          String? fileName,
          String contentType = "image/jpg"}) async =>
      await jobRepository.uploadFile(
          file: file,
          folderPath: folderPath,
          contentType: contentType,
          fileName: fileName);
  Future<void> postSubmitApplication({required ApplyJobModel body}) async =>
      await jobRepository.postSubmitApplication(body);
  Future<ApplicantResponse> getApplicants({required num jobId}) async =>
      await jobRepository.getApplicants(jobId: jobId);

  Future<GetJobResponse> getJobFavorites({int? page}) async =>
      await jobRepository.getJobFavorites(page: page);

  Future<void> postAddJobFavorite({required num jobId}) async =>
      await jobRepository.postAddJobFavorite(jobId: jobId);

  Future<GetJobResponse> getSearchJob(
          {required JobSearchRequest query}) async =>
      await jobRepository.getSearchJob(query: query);

  Future getApplicationDetail({required num applicationId}) async =>
      await jobRepository.getApplicationDetail(applicationId: applicationId);
  Future getJobDetail({required num jobId}) async =>
      await jobRepository.getJobDetail(jobId: jobId);
  Future getApplicationProfile({required num jobId}) async =>
      await jobRepository.getApplicationProfile(jobId: jobId);
  Future deleteJob({required num jobId}) async =>
      await jobRepository.deleteJob(jobId: jobId);
}

final jobUseCaseProvider =
    Provider((ref) => JobUseCase(ref.read(jobRepositoryProvider)));
