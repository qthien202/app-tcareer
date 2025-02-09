import 'dart:io';

import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateJobUseCase {
  final JobRepository jobRepository;
  CreateJobUseCase(this.jobRepository);

  Future<List<Province>> getProvince() async =>
      await jobRepository.getProvince();
  Future<List<District>> getDistrict(num provinceId) async =>
      await jobRepository.getDistrict(provinceId);
  Future<List<Ward>> getWard(num districtId) async =>
      await jobRepository.getWard(districtId);
  Future<void> postCreateJob({required JobModel body}) async =>
      await jobRepository.postCreateJob(body: body);

  Future<String> uploadImage(
          {required File file, required String folderPath}) async =>
      await jobRepository.uploadFile(file: file, folderPath: folderPath);

  Future<void> putUpdateJob(
          {required JobModel body, required num jobId}) async =>
      await jobRepository.putUpdateJob(body: body, jobId: jobId);
}

final createJobUseCaseProvider = Provider((ref) {
  final jobRepository = ref.read(jobRepositoryProvider);
  return CreateJobUseCase(jobRepository);
});
