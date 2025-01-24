import 'dart:convert';

import 'package:app_tcareer/app.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/configs/exceptions/api_exception.dart';
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/features/authentication/data/models/login_response.dart';
import 'package:app_tcareer/src/features/authentication/data/models/refresh_token_request.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:app_tcareer/src/services/custom_cache_manager.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../services.dart';

final apiServiceProvider = Provider<ApiServices>((ref) {
  final dio = Dio();
  dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    var fileResponse = await CustomCacheManager.instance
        .getFileFromCache(options.uri.toString());
    if (fileResponse != null && fileResponse.file.existsSync()) {
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: await fileResponse.file.readAsBytes(),
      ));
    } else {
      final userUtils = ref.read(userUtilsProvider);
      final authToken = await userUtils.getAuthToken();
      options.headers = {
        "Access-Control-Allow-Origin": "*",
        "Authorization": "Bearer $authToken",
        ...options.headers,
      };
      handler.next(options);
    }
  }, onError: (error, handler) async {
    final userUtils = ref.read(userUtilsProvider);
    if (error.response?.statusCode == 401 &&
        await userUtils.getAuthToken() != null) {
      try {
        final refreshToken = await userUtils.getRefreshToken();
        final response =
            await refreshAccessToken(refreshToken: refreshToken, ref: ref);
        if (response != null) {
          Map<String, dynamic> payload =
              JwtDecoder.decode(response.accessToken ?? "");
          print(">>>>>>>>payload: $payload");
          await userUtils.saveAuthToken(
              userId: payload['sub'],
              authToken: response.accessToken ?? "",
              refreshToken: refreshToken);
          final authToken = await userUtils.getAuthToken();
          final options = error.requestOptions;
          options.headers["Authorization"] = "Bearer $authToken";

          return handler.resolve(await dio.fetch(options));
        }
      } catch (e) {
        showSnackBarError("Phiên đăng nhập hết hạn!");
        final refreshTokenNotifier =
            ref.watch(refreshTokenStateProvider.notifier);
        userUtils.clearToken();
        refreshTokenNotifier.setTokenExpired(true);
      }

      // final refreshTokenNotifier =
      //     ref.watch(refreshTokenStateProvider.notifier);
      // refreshTokenNotifier.setTokenExpired(true);
      // await userUtils.clearToken();
    } else {
      // final apiException = ApiException();
      // List<String> errorMessage = apiException.getExceptionMessage(error);
      // List<String> errorMessageStatusCode =
      //     apiException.getHttpStatusMessage(error.response?.statusCode ?? 0);
      // if (errorMessage.isNotEmpty) {
      //   showSnackBarErrorException("${errorMessage[0]}. ${errorMessage[1]}");
      // } else if (error.response?.statusCode == 500) {
      //   showSnackBarErrorException(
      //       "${errorMessageStatusCode[0]}. ${errorMessageStatusCode[1]}");
      // } else {
      handler.reject(error);
      //}
    }
  }, onResponse: (response, handler) async {
    if (response.statusCode == 200 && response.data is List<int>) {
      await CustomCacheManager.instance
          .putFile(response.requestOptions.uri.toString(), response.data);
    }
    final message = handler.next(response);
  }));

  return ApiServices(dio);
});

Future<LoginResponse?> refreshAccessToken(
    {required String refreshToken, required ProviderRef ref}) async {
  final LoginResponse? data;
  final dio = Dio();

  try {
    dio.options.baseUrl = Env.baseUrl;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    final response = await dio.post('auth/refresh',
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }));
    data = LoginResponse.fromJson(response.data);
    return data;
  } on DioException catch (err) {
    return Future.error(err);
  }
  return null;
}

class RefreshTokenStateNotifier extends ChangeNotifier {
  bool isRefreshTokenExpired = false; // Mặc định là false

  void setTokenExpired(bool expired) {
    isRefreshTokenExpired = expired;
  }
}

final refreshTokenStateProvider = ChangeNotifierProvider(
  (ref) => RefreshTokenStateNotifier(),
);
