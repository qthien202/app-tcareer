import 'dart:convert';
import 'dart:io' as io;

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _scopes = [DriveApi.driveScope];

class GoogleDriveService {
  final _driveApi = _createDriveApi();

  GoogleDriveService();

  static Future<DriveApi> _createDriveApi() async {
    final credentials = await loadCredentials();

    final client = await clientViaServiceAccount(credentials, _scopes);

    return DriveApi(client);
  }

  static Future<ServiceAccountCredentials> loadCredentials() async {
    final jsonString =
        await rootBundle.loadString('assets/json/credentials.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return ServiceAccountCredentials.fromJson(jsonMap);
  }

  Future<String> uploadFile(io.File file, String topic, String folderName,
      String mimeType // thêm mimeType vào đây
      ) async {
    final driveApi = await _driveApi;

    const parentFolderId = "18KYXb729bytijEE6dqDIJf2NWOAoruzE";

    final topicFolderId =
        await getOrCreateFolderId(driveApi, topic, parentFolderId);
    if (topicFolderId == null) {
      throw Exception("Could not create or find the topic folder.");
    }

    final folderId =
        await getOrCreateFolderId(driveApi, folderName, topicFolderId);
    if (folderId == null) {
      throw Exception("Could not create the folderName folder.");
    }

    final uuid = Uuid();
    final fileName = uuid.v4();

    final fileContent = await file.readAsBytes();
    final media = Media(Stream.fromIterable([fileContent]), fileContent.length);

    final driveFile = File()
      ..name = fileName
      ..mimeType = mimeType // sử dụng mimeType từ tham số
      ..parents = [folderId];

    try {
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
      final fileId = response.id;

      // URL khác nhau cho image và video
      final fileUrl = mimeType.startsWith('image/')
          ? 'https://drive.google.com/thumbnail?id=$fileId&sz=w1000'
          : 'https://drive.google.com/uc?export=download&id=$fileId';

      return fileUrl;
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }

  Future<String?> getOrCreateFolderId(
      DriveApi driveApi, String folderName, String? parentId) async {
    final query = parentId == null
        ? "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false"
        : "mimeType='application/vnd.google-apps.folder' and name='$folderName' and '$parentId' in parents and trashed=false";

    final results = await driveApi.files.list(
      q: query,
      spaces: 'drive',
    );

    if (results.files?.isNotEmpty == true) {
      return results.files?.first.id!;
    }

    final folderMetadata = File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = parentId != null ? [parentId] : [];

    final folder = await driveApi.files.create(folderMetadata);
    return folder.id!;
  }

  Future<String> uploadFileFromUint8List(Uint8List fileData, String topic,
      String folderName, String mimeType) async {
    final driveApi = await _driveApi;

    const parentFolderId = "18KYXb729bytijEE6dqDIJf2NWOAoruzE";

    final topicFolderId =
        await getOrCreateFolderId(driveApi, topic, parentFolderId);
    if (topicFolderId == null) {
      throw Exception("Could not create or find the topic folder.");
    }

    final folderId =
        await getOrCreateFolderId(driveApi, folderName, topicFolderId);
    if (folderId == null) {
      throw Exception("Could not create the folderName folder.");
    }

    final uuid = Uuid();
    final fileName = uuid.v4();

    // Tạo media từ Uint8List thay vì đọc từ file
    final media = Media(Stream.value(fileData), fileData.length);

    final driveFile = File()
      ..name = fileName
      ..mimeType =
          mimeType // Định dạng MIME của file (image/png, image/jpeg,...)
      ..parents = [folderId];

    try {
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
      final fileId = response.id;
      final fileUrl = 'https://drive.google.com/thumbnail?id=$fileId&sz=w1000';
      return fileUrl;
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }
}

final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService();
});
