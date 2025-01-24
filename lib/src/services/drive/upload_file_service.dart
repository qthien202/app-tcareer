import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/services/drive/upload_data.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class UploadFileService {
  final Dio dio = Dio();

  Future<String> uploadFile(
      {File? file,
      Uint8List? uint8List,
      required String topic,
      required String folderName}) async {
    String? fileUrl;
    dio.options.baseUrl = Env.uploadUrl;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    FormData formData = FormData.fromMap({
      "api_key": Env.uploadKey,
      "file": file != null
          ? await MultipartFile.fromFile(file.path)
          : MultipartFile.fromBytes(uint8List!, filename: "upload.mp4"),
      "folder": "$folderName/$topic",
      "type": "video"
    });
    final response = await dio.post('upload',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }));
    fileUrl = UploadData.fromJson(response.data).secureUrl ?? "";
    return fileUrl;
  }
}

final uploadFileServiceProvider = Provider<UploadFileService>((ref) {
  return UploadFileService();
});
