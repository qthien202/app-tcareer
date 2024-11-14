import 'dart:io';

import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
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

  Future<GetJobResponse> getJobs() async => await jobRepository.getJobs();
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
}

final jobUseCaseProvider =
    Provider((ref) => JobUseCase(ref.read(jobRepositoryProvider)));
