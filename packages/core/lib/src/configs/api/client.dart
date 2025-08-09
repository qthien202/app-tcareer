import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'app_interceptor.dart';

final clientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.baseURL,
  ));

  dio.interceptors.addAll([
    CurlLoggerDioInterceptor(printOnSuccess: true),
    PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true),
    AppInterceptor(ref),
  ]);

  return dio;
});
