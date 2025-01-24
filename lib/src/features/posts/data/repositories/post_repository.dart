import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_comment_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_post_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/like_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/share_post_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/share_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked_request.dart';
import 'package:app_tcareer/src/services/apis/api_service_provider.dart';
import 'package:app_tcareer/src/services/drive/google_drive_service.dart';
import 'package:app_tcareer/src/services/drive/upload_file_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PostRepository {
  final Ref ref;
  final dio = Dio();
  PostRepository(this.ref);

  Future<String> uploadFileFirebase({
    required File file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFile(file, folderPath);
  }

  Future<String> uploadFileFromUint8List({
    required Uint8List file,
    required String folderPath,
  }) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFileFromUint8List(file, folderPath);
  }

  Future<String> uploadFileFromUint8ListVideo(
      {required Uint8List file,
      required String folderPath,
      bool isPreview = false}) async {
    final firebaseStorage = ref.watch(firebaseStorageServiceProvider);
    return firebaseStorage.uploadFileFromUint8ListVideo(file, folderPath,
        isPreview: isPreview);
  }

  Future<String> uploadFile(
      {File? file,
      Uint8List? uint8List,
      required String topic,
      required String folderName}) async {
    final api = ref.watch(uploadFileServiceProvider);
    return api.uploadFile(
        topic: topic, folderName: folderName, file: file, uint8List: uint8List);
  }

  Future<void> createPost({required CreatePostRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    await api.postCreatePost(body: body);
  }

  Future<PostsResponse> getPosts(
      {required String personal, String? userId, int? page}) async {
    final api = ref.watch(apiServiceProvider);
    final userUtils = ref.watch(userUtilsProvider);
    print(">>>>>>refreshToken: ${await userUtils.getRefreshToken()}");
    return await api.getPosts(
        queries:
            PostRequest(personal: personal, profileUserId: userId, page: page));
  }

  Future<LikePostData> postLikePost(String postId, int likeCount) async {
    final api = ref.watch(apiServiceProvider);
    return api.postLikePost(
        body: LikePostRequest(postId: postId, likeCount: likeCount));
  }

  Future<PostsDetailResponse> getPostById(String postId) async {
    final api = ref.watch(apiServiceProvider);
    return api.getPostById(postId: postId);
  }

  Future<void> postCreateComment(
      {required int postId,
      int? parentId,
      required String content,
      List<String>? mediaUrl}) async {
    final api = ref.watch(apiServiceProvider);
    final body = CreateCommentRequest(
        postId: postId,
        commentId: parentId,
        content: content,
        mediaUrl: mediaUrl);
    return api.postCreateComment(body: body);
  }

  Future<Map<dynamic, dynamic>?> getCommentByPostId(String postId) async {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "comments/$postId";
    return await database.getData(path);
  }

  Stream<DatabaseEvent> listenToComments(String postId) {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "comments/$postId";
    return database.listenToData(path);
  }

  Future<void> postLikeComment(String commentId) async {
    final api = ref.watch(apiServiceProvider);
    return api.postLikeComment(
        body: LikeCommentRequest(commentId: num.parse(commentId)));
  }

  Stream<DatabaseEvent> listenToLikeComments(String postId) {
    final database = ref.watch(firebaseDatabaseServiceProvider);
    String path = "likes/$postId";
    return database.listenToData(path);
  }

  Future<SharePostData> postSharePost(
      int postId, String privacy, String body) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postSharePost(
        body: SharePostRequest(postId: postId, privacy: privacy, body: body));
  }

  Future<QuickSearchUserData> getQuickSearchUser(String query) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getQuickSearchUser(query: query);
  }

  Future getSearch(String query) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getSearch(query: query);
  }

  Future<PostsResponse> getSearchPost(
      {required String query, int? page}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getSearchPost(query: query, page: page);
  }

  Future<UserLiked> getUserLiked({int? postId, int? commentId}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.getUserLiked(
        query: UserLikedRequest(postId: postId, commentId: commentId));
  }

  Future<void> deleteComment(String commentId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.deleteComment(commentId: commentId);
  }

  Future<void> putUpdateComment(
      {required String commentId,
      required String postId,
      required String content}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.putUpdateComment(
        body: CreateCommentRequest(
            commentId: int.parse(commentId),
            postId: int.parse(postId),
            content: content),
        commentId: commentId);
  }

  Future<void> putUpdatePost(
      {required String postId, required CreatePostRequest body}) async {
    final api = ref.watch(apiServiceProvider);
    return await api.putUpdatePost(body: body, postId: postId);
  }

  Future<void> deletePost(String postId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.deletePost(postId: postId);
  }

  Future<void> hiddenPost(String postId) async {
    final api = ref.watch(apiServiceProvider);
    return await api.postHiddenPost(postId: postId);
  }
}

final postRepository = Provider((ref) => PostRepository(ref));
