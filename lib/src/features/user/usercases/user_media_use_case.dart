import 'dart:io';

import 'package:app_tcareer/src/features/posts/data/repositories/media_repository.dart';
import 'package:app_tcareer/src/features/user/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class UserMediaUseCase {
  final MediaRepository mediaRepository;
  final UserRepository userRepository;
  UserMediaUseCase(this.mediaRepository, this.userRepository);

  Future<List<AssetPathEntity>> getAlbums({required RequestType type}) async {
    return await mediaRepository.getAlbums(type: type);
  }

  Future<List<AssetEntity>> getMediaFromAlbums({
    required AssetPathEntity album,
    int page = 0,
    int? size,
  }) async {
    return await mediaRepository.getMediaFromAlbum(
        page: page, size: size, album: album);
  }

  Future<bool> requestPermission() async =>
      await mediaRepository.requestPermission();

  Future<String> uploadImage(
          {required File file, required String folderPath}) async =>
      await userRepository.uploadImage(file: file, folderPath: folderPath);
}

final userMediaUseCaseProvider = Provider((ref) {
  final mediaRepositoryProvider = ref.watch(mediaRepository);
  final userRepository = ref.watch(userRepositoryProvider);
  return UserMediaUseCase(mediaRepositoryProvider, userRepository);
});
