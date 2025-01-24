import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/data/repositories/post_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentUseCase {
  final PostRepository postRepository;
  CommentUseCase(this.postRepository);

  Future<Map<dynamic, dynamic>?> getCommentByPostId(String postId) async =>
      await postRepository.getCommentByPostId(postId);
  Stream<DatabaseEvent> listenToComment(String postId) =>
      postRepository.listenToComments(postId);
  Future<void> postLikeComment(String commentId) async =>
      await postRepository.postLikeComment(commentId);

  Stream<DatabaseEvent> listenToLikeComment(String postId) =>
      postRepository.listenToLikeComments(postId);

  Future<UserLiked> getUserLikeComment(int commentId) async {
    return postRepository.getUserLiked(commentId: commentId);
  }

  Future<void> deleteComment(String commentId) async =>
      await postRepository.deleteComment(commentId);
  Future<void> putUpdateComment(
          {required String commentId,
          required String postId,
          required String content}) async =>
      await postRepository.putUpdateComment(
          commentId: commentId, postId: postId, content: content);
}

final commentUseCaseProvider =
    Provider((ref) => CommentUseCase(ref.watch(postRepository)));
