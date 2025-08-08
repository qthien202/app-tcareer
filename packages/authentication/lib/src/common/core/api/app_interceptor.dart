import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../data/models/login_response.dart';
import '../../../data/models/refresh_token_request.dart';
import '../../../utils/snackbar_utils.dart';
import '../../../utils/user_utils.dart';
import '../../configs/app_constants.dart';

class AppInterceptor extends Interceptor {
  final ProviderRef ref;
  AppInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final userUtils = ref.read(userUtilsProvider);
    final authToken = await userUtils.getAuthToken();
    options.headers["Authorization"] = "Bearer $authToken";
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final userUtils = ref.read(userUtilsProvider);
    if (err.response?.statusCode == 401 &&
        await userUtils.getAuthToken() != null) {
      try {
        final refreshToken = await userUtils.getRefreshToken();
        final newToken =
            await refreshAccessToken(refreshToken: refreshToken, ref: ref);
        if (newToken != null) {
          final userId = userUtils.decodeToken(newToken.accessToken!)['sub'];
          await userUtils.saveAuthToken(
            userId: userId,
            authToken: newToken.accessToken!,
            refreshToken: refreshToken,
          );
          err.requestOptions.headers["Authorization"] =
              "Bearer ${newToken.accessToken}";
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        userUtils.clearToken();
        showSnackBarError("Phiên đăng nhập đã hết hạn.");
      }
    }
    return handler.next(err);
  }

  Future<LoginResponse?> refreshAccessToken(
      {required String refreshToken, required ProviderRef ref}) async {
    final LoginResponse? data;
    final dio = Dio();

    try {
      dio.options.baseUrl = AppConstants.baseUrl;
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
}
