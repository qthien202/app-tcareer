import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/services/address/address_services.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/apis/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobRepository {
  final AddressServices addressServices;
  final ApiServices apiServices;
  JobRepository(this.addressServices, this.apiServices);

  Future<List<Province>> getProvince() async =>
      await addressServices.getProvince();
  Future<List<District>> getDistrict(num provinceId) async =>
      await addressServices.getDistrict(provinceId);
  Future<List<Ward>> getWard(num districtId) async =>
      await addressServices.getWard(districtId);

  Future<void> postCreateJob({required JobModel body}) async =>
      await apiServices.postCreateJob(body: body);
}

final jobRepositoryProvider = Provider((ref) {
  final addressServices = ref.read(addressServicesProvider);
  final apiServices = ref.read(apiServiceProvider);
  return JobRepository(addressServices, apiServices);
});
