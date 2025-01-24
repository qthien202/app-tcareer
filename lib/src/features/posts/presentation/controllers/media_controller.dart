import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/controllers/post_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/pages/posting_page.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
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
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaController extends ChangeNotifier {
  final MediaUseCase mediaUseCase;
  MediaController(this.mediaUseCase, this.ref);
  final ChangeNotifierProviderRef<Object?> ref;
  bool permissionGranted = false;
  List<AssetPathEntity> albums = [];
  List<AssetEntity> media = [];
  AssetPathEntity? selectedAlbum;
  TextEditingController contentController = TextEditingController();

  Future<bool> requestPermission() async =>
      await mediaUseCase.requestPermission();

  Future<void> getAlbums() async {
    bool isPermission = await requestPermission();
    if (isPermission) {
      await requestPermissions();
      albums = await mediaUseCase.getAlbums();

      selectedAlbum = albums.first;

      if (media.isEmpty) {
        await getMediaFromAlbum(albums.first);
      }
    }
  }

  Future<void> getMediaFromAlbum(AssetPathEntity album) async {
    media = await mediaUseCase.getMediaFromAlbum(album: album);
    await prefetchVideoDurations();
    // notifyListeners();
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
  Future<void> clearData(BuildContext context) async {
    bool hasChanged = await hasChangedSelectedAssets();
    if (isAutoPop) {
      return;
    }
    if (selectedAsset.isEmpty ||
        !hasChanged ||
        imagePaths.length == selectedAsset.length) {
      context.pop();
    } else {
      showModalPopup(
          context: context,
          onPop: () async {
            // selectedAsset.clear();
            // assetIndices.clear();
            Future.microtask(() {
              selectedAsset.clear();
              context.pop();
              context.pop();
            });
          });
    }
  }

  List<String> imagePaths = [];
  List<String> videoPaths = [];

  Future<void> getAssetPaths(BuildContext context) async {
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("selectedAsset");
    await userUtils.removeCache("imageCache");
    final posting = ref.read(postingControllerProvider);

    imagePaths.removeWhere((path) => !path.isImageNetWork);
    // Clear videoPaths as well

    for (AssetEntity asset in selectedAsset) {
      File? file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.image) {
          imagePaths.add(file.path);
        } else if (asset.type == AssetType.video) {
          if (videoPaths.isNotEmpty && videoPaths.first.isVideo == true) {
            print(">>>>>>>>>1");
            bool? shouldReplace = await showCupertinoModalPopup<bool>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  message: const Text(
                      'Bạn có muốn thay thế video bài viết hiện tại?'),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Quay lại'),
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('Tiếp tục',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                );
              },
            );

            if (shouldReplace == true) {
              videoPaths.clear();
              videoPaths.add(file.path);

              await generateVideoThumbnail();
            }
          } else {
            videoPaths.clear();

            videoPaths.add(file.path);

            await generateVideoThumbnail();
          }
        }
      }
    }

    notifyListeners();
    print("Image Paths: $imagePaths");
    print("Video Paths: $videoPaths");
    if (imagePaths.any((image) => image.isImageNetWork) ||
        videoPaths.any((videoPaths) => videoPaths.isVideoNetWork)) {
      posting.setAction("edit");
    }
    context.pop();
  }

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
    // notifyListeners();
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
    if (isComment != false &&
        selectedAsset.length == 1 &&
        !selectedAsset.contains(asset)) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 1 ảnh hoặc 1 video");
      return;
    }
    if (imagePaths.any((image) => image.isImageNetWork) &&
        asset.type == AssetType.video) {
      showSnackBarError("Bạn chỉ được phép chọn thêm ảnh");
      return;
    }

    if (asset.type == AssetType.video &&
        selectedAsset.any((a) => a.type == AssetType.image)) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 10 ảnh hoặc 1 video");
      return;
    }
    if (asset.type == AssetType.image &&
        selectedAsset.any((a) =>
            a.type == AssetType.video && !selectedAsset.contains(asset))) {
      showSnackBarError("Bạn đã chọn 1 video, không thể chọn thêm ảnh.");
      return;
    }
    if (asset.type == AssetType.video &&
        selectedAsset.any((a) =>
            a.type == AssetType.video && !selectedAsset.contains(asset))) {
      showSnackBarError("Bạn chỉ có thể chọn tối đa 1 video");
      return;
    }
    if (asset.type == AssetType.image) {
      if (selectedAsset.length >= 10 && !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh");
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

      if (selectedAsset.length >= 10 && !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh hoặc 1 video");
        return;
      } else if (selectedAsset
              .where((a) => a.type == AssetType.video)
              .isNotEmpty &&
          !selectedAsset.contains(asset)) {
        showSnackBarError("Bạn chỉ có thể chọn tối đa là 1 video");
        return;
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

    notifyListeners();
  }

  Future<void> setCacheSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String> assetIds = selectedAsset.map((asset) => asset.id).toList();
    await userUtils.saveCacheList(key: "selectedAsset", value: assetIds);
  }

  Future<void> loadSelectedAsset() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    if (assetIds != null) {
      selectedAsset.clear();
      for (String id in assetIds) {
        AssetEntity? asset = await AssetEntity.fromId(id);
        if (asset != null) {
          selectedAsset.add(asset);
        }
      }
      notifyListeners();
    }
  }

  Future<void> setCache() async {
    await setCacheSelectedAssets();
  }

  Future<void> loadCache() async {
    await loadSelectedAsset();
    await loadAssetIndices();
  }

  Future<void> loadAssetIndices() async {
    assetIndices =
        selectedAsset.map((asset) => selectedAsset.indexOf(asset)).toList();
    notifyListeners();
  }

  void showModalPopup({
    required BuildContext context,
    required void Function() onPop,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            'Bỏ thay đổi?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          message: const Text('Nếu quay lại sẽ bỏ những thay đổi đã thực hiện'),
          actions: <Widget>[
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: onPop,
                child: const Text(
                  'Quay lại',
                )),
            CupertinoActionSheetAction(
                child: const Text(
                  'Tiếp tục chỉnh sửa',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => context.pop()),
          ],
        );
      },
    );
  }

  Future<void> removeAssets() async {
    imagePaths.clear();
    videoPaths.clear();
    videoThumbnail.clear();
    selectedAsset.clear();
    notifyListeners();
  }

  List<String> videoThumbnail = [];
  Future<void> generateVideoThumbnail() async {
    if (videoPaths.isNotEmpty) {
      final thumbnail = await VideoThumbnail.thumbnailFile(
          video: videoPaths.first,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          quality: 100);
      videoThumbnail.add(thumbnail!);
    }
  }

  Future<void> removeImage(int index) async {
    imagePaths.removeAt(index);
    if (selectedAsset.isNotEmpty) {
      selectedAsset.removeAt(index);
    }
    notifyListeners();
  }

  Future<void> removeVideo() async {
    videoPaths.clear();
    videoThumbnail.clear();

    selectedAsset.clear();
    notifyListeners();
  }

  Future<void> deleteVideo() async {
    videoPaths.clear();
    videoThumbnail.clear();

    notifyListeners();
  }

  Future<bool> hasChangedSelectedAssets() async {
    final userUtils = ref.watch(userUtilsProvider);
    List<String>? assetIds = await userUtils.loadCacheList("selectedAsset");
    return assetIds?.length != selectedAsset.length;
  }

  Future<void> pickImageCamera(BuildContext context) async {
    final image = await mediaUseCase.pickImageCamera();
    imagePaths.add(image?.path ?? "");
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
}
