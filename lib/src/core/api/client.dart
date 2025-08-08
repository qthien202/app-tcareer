import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../configs/app_constants.dart';
import '../core.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.addAll([
    CurlLoggerDioInterceptor(printOnSuccess: true),
    PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true),
    AppInterceptor(ref),
  ]);

  return dio;
});
