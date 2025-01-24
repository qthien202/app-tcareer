import 'dart:io';
import 'package:app_tcareer/src/features/jobs/data/models/add_job_topic_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/topic_job_favorite_response.dart';
import 'package:app_tcareer/src/features/user/data/models/change_password_request.dart';
import 'package:app_tcareer/src/features/user/data/models/create_resume_request.dart';
import 'package:app_tcareer/src/features/user/data/models/resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final Ref ref;
  UserRepository(this.ref);

  Future<Users> getUserInfo() async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserInfo();
  }

  Future<Users> getUserById(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserById(userId: userId);
  }

  Future getFollower(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getFollowers(userId: userId);
  }

  Future getFriends(String userId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getFriends(userId: userId);
  }

  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      Map<String, Object?>? dataUpdateDisconnect}) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.addData(
        path: path, data: data, dataUpdate: dataUpdateDisconnect);
  }

  Future<void> updateData(
      {required String path, required Map<String, dynamic> data}) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.updateData(path: path, data: data);
  }

  Future<void> monitorConnection(
      void Function(DatabaseEvent event)? onData) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.monitorConnection(onData);
  }

  Future<Map<dynamic, dynamic>?> getData(String path) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    return await database.getData(path);
  }

  Future<void> putUpdateProfile({required UpdateProfileRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.putUpdateProfile(body: body);
  }

  Future<String> uploadImage(
      {required File file, required String folderPath}) async {
    final storage = ref.watch(firebaseStorageServiceProvider);
    return await storage.uploadFile(file, folderPath);
  }

  Future postCreateResume({required CreateResumeRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postCreateResume(body: body);
  }

  Future<ResumeModel> getResume({String? userId}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getResume(userId: userId);
  }

  Future<GetJobResponse> getPostedJob({int? page, num? userId}) async {
    final api = ref.read(apiServiceProvider);
    return await api.getPostedJob(page: page, userId: userId);
  }

  Future<void> putChangPassword({required ChangePasswordRequest body}) async {
    final api = ref.read(apiServiceProvider);
    return await api.putChangePassword(body: body);
  }

  Future<TopicJobFavoriteResponse> getTopicJobFavorite() async {
    final api = ref.read(apiServiceProvider);
    return await api.getTopicJobFavorite();
  }

  Future<void> postAddJobTopic({required AddJobTopicRequest body}) async {
    final api = ref.read(apiServiceProvider);
    return await api.postAddJobTopic(body: body);
  }

  Future<List<JobTopicModel>> getJobTopic() async {
    final api = ref.read(apiServiceProvider);
    return await api.getJobTopic();
  }
}

final userRepositoryProvider = Provider((ref) => UserRepository(ref));
