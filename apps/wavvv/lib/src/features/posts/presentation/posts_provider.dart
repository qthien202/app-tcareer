import 'dart:async';

import 'package:app_tcareer/src/features/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/features/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/search_post_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/video_player_controller.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/search_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/comment_controller.dart';
import 'controllers/post_controller.dart';

final postControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  return PostController(postUseCase, ref);
});

final postingControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  return PostingController(postUseCase, ref);
});

final mediaControllerProvider = ChangeNotifierProvider((ref) {
  final mediaUseCase = ref.read(mediaUseCaseProvider);
  return MediaController(mediaUseCase, ref);
});

final commentControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  final commentUseCase = ref.read(commentUseCaseProvider);
  final mediaUseCase = ref.read(mediaUseCaseProvider);
  return CommentController(postUseCase, ref, commentUseCase, mediaUseCase);
});

final searchPostControllerProvider = ChangeNotifierProvider((ref) {
  final searchUseCase = ref.watch(searchUseCaseProvider);
  final postUseCase = ref.read(postUseCaseProvider);
  final userUtils = ref.read(userUtilsProvider);
  return SearchPostController(searchUseCase, postUseCase, userUtils);
});
// Provider để lấy loại ảnh
final imageOrientationProvider =
    FutureProvider.family<ImageOrientation, dynamic>((ref, imageSource) async {
  try {
    return await getImageOrientation(imageSource);
  } catch (e) {
    print('Error in imageOrientationProvider: $e');
    rethrow;
  }
});
