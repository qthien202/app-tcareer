import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/services/address/district.dart';
import 'package:app_tcareer/src/services/address/province.dart';
import 'package:app_tcareer/src/services/address/ward.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AddressServices {
  final Dio dio = Dio();

  Future<List<Province>> getProvince() async {
    List<Province> provinces = [];
    dio.options.baseUrl = Env.addressUrl;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final token = Env.addressToken;
    final response =
    await dio.get('province', options: Options(headers: {'token': token}));
    if (response.data != null && response.data['data'] != null) {
      provinces = (response.data['data'] as List).map((e) {
        return Province.fromJson(e);
      }).toList();
    }
    return provinces;
  }

  Future<List<District>> getDistrict(num provinceId) async {
    List<District> districts = [];
    dio.options.baseUrl = Env.addressUrl;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final token = Env.addressToken;
    final response = await dio.get('district?province_id=$provinceId',
        options: Options(headers: {'token': token}));
    if (response.data != null && response.data['data'] != null) {
      districts = (response.data['data'] as List).map((e) {
        return District.fromJson(e);
      }).toList();
    }
    return districts;
  }

  Future<List<Ward>> getWard(num districtId) async {
    List<Ward> wards = [];
    dio.options.baseUrl = Env.addressUrl;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final token = Env.addressToken;
    final response = await dio.get('ward?district_id=$districtId',
        options: Options(headers: {'token': token}));
    if (response.data != null && response.data['data'] != null) {
      wards = (response.data['data'] as List).map((e) {
        return Ward.fromJson(e);
      }).toList();
    }
    return wards;
  }
}

final addressServicesProvider = Provider((ref) => AddressServices());
