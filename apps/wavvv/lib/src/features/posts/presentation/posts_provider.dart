import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/search_post_controller.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/search_use_case.dart';
import 'package:core/core.dart';
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
