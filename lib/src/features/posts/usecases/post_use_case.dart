import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/features/authentication/domain/login_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_detail_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/data/models/share_post_data.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/data/repositories/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/like_post_data.dart';

class PostUseCase {
  final PostRepository postRepository;
  PostUseCase(this.postRepository);
  Future<post.PostsResponse> getPost(
          {required String personal, String? userId, int? page}) async =>
      await postRepository.getPosts(
          personal: personal, userId: userId, page: page);
  Future<String> uploadFileFireBase({
    required File file,
    required String folderPath,
  }) async =>
      await postRepository.uploadFileFirebase(
        file: file,
        folderPath: folderPath,
      );

  Future<String> uploadFile(
          {File? file,
          Uint8List? uint8List,
          required String topic,
          required String folderName}) async =>
      await postRepository.uploadFile(
          file: file,
          topic: topic,
          folderName: folderName,
          uint8List: uint8List);

  Future<String> uploadFileFromUint8List({
    required Uint8List file,
    required String folderPath,
  }) async =>
      await postRepository.uploadFileFromUint8List(
        file: file,
        folderPath: folderPath,
      );

  Future<String> uploadFileFromUint8ListPreview(
          {required Uint8List file,
          required String folderPath,
          bool isPreview = false}) async =>
      await postRepository.uploadFileFromUint8ListVideo(
          file: file, folderPath: folderPath, isPreview: isPreview);

  Future<void> createPost({required CreatePostRequest body}) async =>
      await postRepository.createPost(body: body);

  Future<void> setLikePost(
      {required int index,
      required String postId,
      required List<post.Data> postCache}) async {
    final currentPost = postCache[index];

    // await Future.delayed(
    //     const Duration(milliseconds: 500)); // Chờ một thời gian (nếu cần)

    try {
      LikePostData likeData = await postRepository.postLikePost(postId, 0);

      postCache[index] =
          currentPost.copyWith(likeCount: likeData.data?.likeCount);
    } catch (e) {}
  }

  Future<void> postLikePost(
          {required String postId,
          required int index,
          required List<post.Data> postCache}) async =>
      await setLikePost(index: index, postId: postId, postCache: postCache);

  Future<LikePostData> postLikePostDetail(String postId, int likeCount) async =>
      await postRepository.postLikePost(postId, likeCount);

  Future<PostsDetailResponse> getPostById(String postId) async =>
      await postRepository.getPostById(postId);

  Future<void> postCreateComment(
          {required int postId,
          int? parentId,
          required String content,
          List<String>? mediaUrl}) async =>
      await postRepository.postCreateComment(
          postId: postId,
          content: content,
          mediaUrl: mediaUrl,
          parentId: parentId);

  Future<SharePostData> postSharePost(
      {required int postId,
      required String privacy,
      required String body}) async {
    return postRepository.postSharePost(postId, privacy, body);
  }

  Future<UserLiked> getUserLikePost(int postId) async {
    return postRepository.getUserLiked(postId: postId);
  }

  Future<void> putUpdatePost(
          {required String postId, required CreatePostRequest body}) async =>
      await postRepository.putUpdatePost(postId: postId, body: body);

  Future<void> deletePost(String postId) async =>
      await postRepository.deletePost(postId);

  Future<void> hiddenPost(String postId) async =>
      await postRepository.hiddenPost(postId);
}

final postUseCaseProvider =
    Provider((ref) => PostUseCase(ref.watch(postRepository)));
