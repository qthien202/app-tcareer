import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/controllers/job_chat_controller.dart';
import 'package:app_tcareer/src/features/jobs/chat/usecases/job_chat_use_case.dart';

import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class JobChatMediaController extends ChangeNotifier {
  final MediaUseCase mediaUseCase;
  final JobChatUseCase chatUseCase;
  JobChatMediaController(this.mediaUseCase, this.ref, this.chatUseCase);
  final ChangeNotifierProviderRef<Object?> ref;
  bool permissionGranted = false;
  List<AssetPathEntity> albums = [];
  List<AssetEntity> media = [];
  AssetPathEntity? selectedAlbum;

  Future<bool> requestPermission() async =>
      await mediaUseCase.requestPermission();

  Future<void> getAlbums() async {
    bool isPermission = await requestPermission();
    if (isPermission) {
      await requestPermissions();
      albums = await mediaUseCase.getAlbums();

      selectedAlbum = albums.first;
      notifyListeners();
      if (media.isEmpty) {
        await getMediaFromAlbum(albums.first);
      }
    }
  }

  int albumSize = 18;
  // int albumPage = 1;
  Future<void> getMediaFromAlbum(AssetPathEntity album) async {
    media = await mediaUseCase.getMediaFromAlbum(album: album, size: albumSize);
    await prefetchVideoDurations();
    notifyListeners();
  }

  Future<void> loadMore() async {
    albumSize += 18;

    await getMediaFromAlbum(selectedAlbum!);
  }

  Future<void> selectAlbum(album) async {
    selectedAlbum = album;
    await getMediaFromAlbum(selectedAlbum!);
    setIsShowPopUp(false);
    notifyListeners();
  }

  Map<String, Uint8List?> cachedThumbnails = {};

  bool isShowPopUp = false;

  void setIsShowPopUp(bool value) {
    isShowPopUp = value;
    notifyListeners();
  }

  bool isAutoPop = false;

  void resetAutoPop() {
    isAutoPop = false;
  }

  Map<String, Duration?> cachedVideoDurations = {};

  Future<void> prefetchVideoDurations() async {
    for (var item in media) {
      if (item.type == AssetType.video) {
        final duration = await getVideoDuration(item);
        cachedVideoDurations[item.id] = duration;
      }
    }
    print(">>>>>>>>>>$cachedVideoDurations");
    notifyListeners();
  }

  Future<Duration?> getVideoDuration(AssetEntity asset) async {
    if (asset.type == AssetType.video) {
      return asset.videoDuration;
    }
    return null;
  }

  List<AssetEntity> selectedAsset = [];
  List<int> assetIndices = [];
  Future<void> addAsset({
    required AssetEntity asset,
    required BuildContext context,
    bool? isComment,
  }) async {
    if (asset.type == AssetType.video &&
        selectedAsset.where((a) => a.type == AssetType.video).length >= 5) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 5 video");
      return;
    }

    if (asset.type == AssetType.image) {
      if (selectedAsset.length >= 10 && !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh và video");
        return;
      }
    } else if (asset.type == AssetType.video) {
      final videoFile = await asset.file; // Lấy file video
      if (videoFile != null) {
        final videoSize = await videoFile.length();
        if (videoSize > 10 * 1024 * 1024) {
          showSnackBarError("Video phải có kích thước dưới 10MB");
          return;
        }
      }
    }

    if (selectedAsset.contains(asset)) {
      selectedAsset.remove(asset);
    } else {
      selectedAsset.add(asset);
    }

    // Cập nhật chỉ số của các tài sản đã chọn
    assetIndices =
        selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
    print(">>>>>>>>>>assets: $selectedAsset");
    notifyListeners();
  }

  Future<void> loadAssetIndices() async {
    assetIndices =
        selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
    notifyListeners();
  }

  List<String> mediaUrl = [];
  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> uploadMedia(BuildContext context) async {
    final chatController = ref.read(jobChatControllerProvider);
    await chatController.setIsShowMedia(context);
    AppUtils.futureApi(
      () async {
        mediaUrl.clear();
        final uuid = Uuid();
        final id = uuid.v4();
        for (String path in mediaPath) {
          if (path.isVideoLocal) {
            String videoUrl = await chatUseCase.uploadVideo(
                file: File(path), folderName: "video", topic: "chat");
            mediaUrl.add(videoUrl);
          } else {
            String imageUrl = await chatUseCase.uploadImage(
                file: File(path), folderPath: "Chats/$id");
            mediaUrl.add(imageUrl);
          }
        }

        await chatController.sendMessageWithMedia(mediaUrl);
        mediaPath.clear();
        mediaLocalPath.clear();
        media.clear();
      },
      context,
      (value) {},
    );
  }

  Future<String?> generateVideoThumbnail(String videoPath) async {
    String? thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 100);
    return thumbnail;
  }

  List<String> mediaPath = [];
  List<String> mediaLocalPath = [];
  Future<void> getAssetPaths(BuildContext context) async {
    // imagePaths.clear();
    // videoPaths.clear();
    for (AssetEntity asset in selectedAsset) {
      File? file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.image) {
          mediaPath.add(file.path);
          mediaLocalPath.add(file.path);
        } else {
          mediaPath.add(file.path);
          String? thumbnail = await generateVideoThumbnail(file.path);
          mediaLocalPath.add(thumbnail ?? "");
        }
      }
    }
    await updateMediaLocalConversation();
  }

  Future<void> updateMediaLocalConversation() async {
    final chatController = ref.watch(jobChatControllerProvider);
    final userUtil = ref.watch(userUtilsProvider);
    num senderId = num.parse(await userUtil.getUserId());
    final newMessage = MessageModel(
        conversationId: chatController.conversationData?.conversation?.id,
        mediaUrl: mediaLocalPath,
        createdAt: DateTime.now().toIso8601String(),
        senderId: senderId,
        status: 'sent',
        type: 'temp');

    chatController.messages.add(newMessage);
    final messageJson = jsonEncode(
        chatController.messages.map((message) => message.toJson()).toList());

    // mediaLocalPath.clear();
    notifyListeners();
  }

  Future<bool> hasChangedSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    return assetIds?.length != selectedAsset.length;
  }

  Future<void> pickImageCamera(BuildContext context) async {
    final image = await mediaUseCase.pickImageCamera();
    mediaPath.add(image?.path ?? "");
    notifyListeners();
    context.pop();
  }

  Future<void> requestPermissions() async {
    if (await Permission.manageExternalStorage.isGranted == false) {
      await Permission.manageExternalStorage.request();
    }

    if (await Permission.mediaLibrary.isGranted == false) {
      await Permission.mediaLibrary.request();
    }

    if (await Permission.storage.isGranted == false) {
      await Permission.storage.request();
    }
  }

  bool isMaxChildSizeMedia = false;
  Future<void> setIsMaxChildSizeMedia(bool value) async {
    isMaxChildSizeMedia = value;
    notifyListeners();
  }
}

final jobChatMediaControllerProvider = ChangeNotifierProvider((ref) {
  final mediaUseCase = ref.watch(mediaUseCaseProvider);
  final chatUseCase = ref.watch(jobChatUseCaseProvider);
  return JobChatMediaController(mediaUseCase, ref, chatUseCase);
});
