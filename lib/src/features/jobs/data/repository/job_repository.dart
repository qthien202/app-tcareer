import 'package:app_tcareer/src/services/address/address_services.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobRepository {
  final AddressServices addressServices;
  JobRepository(this.addressServices);

  Future<List<Province>> getProvince() async =>
      await addressServices.getProvince();
  Future<List<District>> getDistrict(num provinceId) async =>
      await addressServices.getDistrict(provinceId);
  Future<List<Ward>> getWard(num districtId) async =>
      await addressServices.getWard(districtId);
}

final jobRepositoryProvider = Provider((ref) {
  final addressServices = ref.read(addressServicesProvider);
  return JobRepository(addressServices);
});
