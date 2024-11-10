import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_roles_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobUseCase {
  final JobRepository jobRepository;
  JobUseCase(this.jobRepository);

  Future<List<JobTopicModel>> getJobTopic() async =>
      await jobRepository.getJobTopic();

  Future<List<JobRolesModel>> getJobRoles(num topicId) async =>
      await jobRepository.getJobRoles(topicId);

  Future<GetJobResponse> getJobs() async => await jobRepository.getJobs();
}

final jobUseCaseProvider =
    Provider((ref) => JobUseCase(ref.read(jobRepositoryProvider)));
