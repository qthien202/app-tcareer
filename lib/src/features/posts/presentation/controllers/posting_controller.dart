import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/extensions/file_type_extension.dart';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/posts/data/models/create_post_request.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_edit.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/shared_post.dart';

class PostingController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final Ref ref;
  PostingController(this.postUseCase, this.ref);

  Future<void> sharePost({required String url, required String title}) async {
    await Share.share(url, subject: title);
  }

  Future<void> loadCacheImage() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    List<String>? imageCache = await userUtils.loadCacheList("imageCache");
    if (imageCache?.isNotEmpty == true) {
      mediaController.imagePaths = imageCache!;
      notifyListeners();
    }
  }

  Future<void> loadVideoCache() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    List<String>? videoCache = await userUtils.loadCacheList("videoCache");
    if (videoCache?.isNotEmpty == true) {
      mediaController.videoPaths = videoCache!;
      notifyListeners();
    }
  }

  Future<void> loadContentCache() async {
    final userUtils = ref.watch(userUtilsProvider);
    String? contentCache = await userUtils.loadCache("postContent");
    final mediaController = ref.watch(mediaControllerProvider);
    if (contentCache != null) {
      mediaController.contentController.text = contentCache;
      userUtils.removeCache("postContent");
      notifyListeners();
    }
  }

  Future<void> loadPostCache() async {
    await loadContentCache();
    await loadCacheImage();
    await loadVideoCache();
  }

  Future<void> clearPostCache(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    await userUtils.removeCache("imageCache");
    await userUtils.removeCache("selectedAsset");
    mediaController.selectedAsset.clear();
    mediaController.imagePaths.clear();
    mediaController.contentController.clear();
    imagesWeb.clear();
    videoPicked?.clear();
    mediaController.videoPaths.clear();
    mediaController.videoThumbnail.clear();
    notifyListeners();
    context.goNamed("home");
  }

  Future<void> setCacheImagePath() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.read(mediaControllerProvider);

    await userUtils.saveCacheList(
        key: "imageCache", value: mediaController.imagePaths);
  }

  Future<void> setCacheContent() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    await userUtils.saveCache(
        key: "postContent",
        value: mediaController.contentController.text ?? "");
  }

  Future<void> setCacheVideo() async {
    final userUtils = ref.watch(userUtilsProvider);
    final mediaController = ref.read(mediaControllerProvider);

    await userUtils.saveCacheList(
        key: "videoCache", value: mediaController.videoPaths);
  }

  Future<void> setPostCache(BuildContext context) async {
    final mediaController = ref.read(mediaControllerProvider);
    await setCacheContent();
    await setCacheImagePath();
    await mediaController.setCache();
    showSnackBar("Bài viết đã được lưu làm bản nháp");
    context.goNamed("home");
  }

  void showModalPopup(
      {required BuildContext context,
      required void Function() onSave,
      required void Function() onDiscard}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            'Bạn có muốn lưu bài viết này dưới dạng nháp?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          message: const Text('Bài viết sẽ được hiển thị khi bạn quay trở lại'),
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: onSave,
                child: const Text(
                  'Lưu',
                  style: TextStyle(color: Colors.blue),
                )),
            CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: onDiscard,
                child: const Text('Xóa bài viết')),
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

  Future<void> showDialog(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    if (mediaController.imagePaths.any((image) => image.isImageNetWork) ||
        mediaController.videoPaths.any((video) => video.isVideoNetWork)) {
      print(">>>>>>>>2");
      clearPostCache(context);
      context.goNamed("home");
    } else if (mediaController.imagePaths.isNotEmpty ||
        mediaController.videoPaths.isNotEmpty &&
            mediaController.contentController.text != null) {
      print(">>>>>>>>1");
      showModalPopup(
          context: context,
          onSave: () async => await setPostCache(context),
          onDiscard: () async => await clearPostCache(context));
    } else {
      print(">>>>>>>>3");
      clearPostCache(context);
      context.goNamed("home");
    }
  }

  bool isLoading = false;
  double loadingProgress = 0.0;
  void setIsLoading(bool value) {
    isLoading = value;

    notifyListeners();
  }

  void setLoadingProgress(double value) {
    loadingProgress = value;
    notifyListeners();
  }

  Future<void> createPost(BuildContext context) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final postController = ref.watch(postControllerProvider);

    context.goNamed("home");
    loadingProgress = 0.0;
    await updatePostTemp();
    AppUtils.futureApi(() async {
      setLoadingProgress(0.25);
      if (mediaController.imagePaths.isNotEmpty ||
          imagesWeb.isNotEmpty == true) {
        await uploadImageFile();
        setLoadingProgress(0.5);
      }
      if (mediaController.videoPaths.isNotEmpty) {
        await uploadVideo();
        setLoadingProgress(0.5);
      }
      setLoadingProgress(0.75);
      await postUseCase.createPost(
          body: CreatePostRequest(
              body: mediaController.contentController.text,
              privacy: selectedPrivacy,
              mediaUrl: mediaUrl));
      setLoadingProgress(1);
      showSnackBar("Tạo bài viết thành công");
      clearPostCache(context);
      await postController.refresh();
    }, context, setIsLoading);
    notifyListeners();
  }

  Future<void> updatePostTemp() async {
    final postController = ref.watch(postControllerProvider);
    final userController = ref.watch(userControllerProvider);
    final media = ref.watch(mediaControllerProvider);
    final user = userController.userData?.data;

    final newPost = post.Data(
        userId: user?.id,
        title: "temp",
        body: media.contentController.text,
        fullName: user?.fullName,
        avatar: user?.avatar,
        createdAt: AppUtils.formatTime(DateTime.now().toIso8601String()),
        privacy: selectedPrivacy,
        mediaUrl: media.imagePaths.isNotEmpty
            ? media.imagePaths
            : media.videoThumbnail);
    postController.postCache.insert(0, newPost);
    notifyListeners();
  }

  List<String> mediaUrl = [];
  Future<void> uploadImageFile() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.imagePaths) {
      if (!asset.isImageNetWork) {
        String? assetPath = await AppUtils.compressImage(asset);
        // String url = await postUseCase.uploadImage(
        //     file: File(assetPath ?? ""), folderPath: path);
        String url = await postUseCase.uploadFileFireBase(
            file: File(assetPath ?? ""), folderPath: "Posts/$id");

        mediaUrl.add(url);
      } else {
        mediaUrl.add(asset);
      }
    }
    // notifyListeners();
  }

  // Future<void> uploadImage() async {
  //   final mediaController = ref.watch(mediaControllerProvider);
  //   // if (mediaController.imagePaths.isNotEmpty) {
  //     await uploadImageFile();
  //   // }
  //   // if (imagesWeb.isNotEmpty == true) {
  //   //   await uploadImageFromUint8List();
  //   // }
  // }

  Future<void> uploadVideo() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final videoPaths = mediaController.videoPaths;
    if (mediaController.videoPaths.any((video) => !video.isVideo)) {
      String? video = videoPaths.first;
      String videoUrl = await postUseCase.uploadFile(
        topic: "post",
        folderName: "video",
        file: File(video),
      );
      mediaUrl.add(videoUrl);
    } else {
      print(">>>>>>>>2");
      mediaUrl.add(videoPaths.first);
    }
  }

  List<String> mediaPreviewUrl = [];

  String selectedPrivacy = "Public";

  Future<void> selectPrivacy(String privacy, BuildContext context) async {
    selectedPrivacy = privacy;

    context.pop();
    notifyListeners();
  }

  int activeIndex = 0;

  void setActiveIndex(index) {
    activeIndex = index;
    notifyListeners();
  }

  List<Uint8List> imagesWeb = [];

  String? videoUrlWeb;
  Uint8List? videoPicked;
  Future<void> pickMediaWeb(BuildContext context) async {
    final mediaUseCase = ref.watch(mediaUseCaseProvider);
    final postUseCase = ref.watch(postUseCaseProvider);
    final pickedFile = await mediaUseCase.pickMediaWeb();

    for (var asset in pickedFile!) {
      if (asset.isImage()) {
        if (imagesWeb.length == 10) {
          showSnackBarError("Bạn chỉ có thể chọn tối đa là 10 ảnh");
          return;
        }
        videoPicked = null;
        Uint8List image = await asset.readAsBytes();
        imagesWeb.add(image);
      }
      if (asset.isVideo()) {
        final fileSizeInBytes = await asset.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 30) {
          showSnackBarError("Video phải có kích thước dưới 30MB");
          return;
        }

        imagesWeb.clear();
        videoPicked = await asset.readAsBytes();
        final uuid = Uuid();
        final id = uuid.v4();

        AppUtils.loadingApi(() async {
          String videoId = await postUseCase.uploadFile(
              folderName: id, topic: "Posts", uint8List: videoPicked!);
        }, context);
      }
    }

    notifyListeners();
  }

  Future<void> uploadImageFromUint8List() async {
    mediaUrl.clear();

    final uuid = Uuid();
    final id = uuid.v4();
    for (Uint8List asset in imagesWeb) {
      // asset = await AppUtils.compressImageWeb(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFileFromUint8List(
          file: asset, folderPath: "Posts/Images/$id");
      mediaUrl.add(url);
    }
  }

  Future<void> uploadVideoFromUint8List() async {
    mediaUrl.add(videoUrlWeb!);
  }

  Future<void> setPostEdit(
      {required PostEdit postEdit, required String postId}) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final post = postEdit.post;
    selectedPrivacy = post?.privacy ?? "";
    mediaController.contentController.text = post?.body ?? "";

    if (post?.mediaUrl?.isNotEmpty == true &&
        post?.mediaUrl?.any((media) => media.isVideo) == true) {
      mediaController.videoPaths = post?.mediaUrl ?? [];
    } else {
      mediaController.imagePaths = post?.mediaUrl ?? [];
    }
    print(">>>>>>>>>>>mediaUrl: $mediaUrl");
    postId = postId;
    notifyListeners();
  }

  String? postId;
  Future<void> showModalPost({
    bool isShared = false,
    PostEdit? postEdit,
    required String postId,
    required BuildContext context,
    required String userId,
  }) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: () {
                  context.pop();
                  context.pushNamed("posting",
                      extra: postEdit,
                      queryParameters: {"postId": postId, "action": "edit"});
                },
                child: const Text(
                  'Chỉnh sửa bài viết',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            Visibility(
              // visible: currentUser,
              child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await showDeleteConfirm(context: context, postId: postId);
                  },
                  child: const Text(
                    'Xóa',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  Future<void> updatePost(
      {required String postId, required BuildContext context}) async {
    final mediaController = ref.watch(mediaControllerProvider);
    final postController = ref.watch(postControllerProvider);

    context.goNamed("home");
    loadingProgress = 0.0;

    AppUtils.futureApi(() async {
      setLoadingProgress(0.25);
      if (mediaController.imagePaths.isNotEmpty) {
        await uploadImageFile();
        setLoadingProgress(0.5);
      }
      if (mediaController.videoPaths.isNotEmpty) {
        await uploadVideo();
        setLoadingProgress(0.5);
      }
      setLoadingProgress(0.75);

      await postUseCase.putUpdatePost(
          postId: postId,
          body: CreatePostRequest(
              body: mediaController.contentController.text,
              privacy: selectedPrivacy,
              mediaUrl: mediaUrl));
      setLoadingProgress(1);
      showSnackBar("Cập nhật bài viết thành công");
      clearPostCache(context);
      await postController.refresh();
    }, context, setIsLoading);
    notifyListeners();
  }

  // String? content;
  // Future<void> setContent(value) async {
  //   content = value;
  //   notifyListeners();
  // }

  Future<void> showDeleteConfirm(
      {required BuildContext context, required String postId}) async {
    await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: const Text('Bạn có chắc muốn xóa bài viết này?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                'Xóa',
              ),
              onPressed: () => deletePost(context: context, postId: postId),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Quay lại',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePost(
      {required BuildContext context, required String postId}) async {
    final postController = ref.watch(postControllerProvider);

    AppUtils.futureApi(() async {
      postController.postCache
          .removeWhere((post) => post.id == int.parse(postId));
      notifyListeners();
      context.pop();
      await postUseCase.deletePost(postId);
    }, context, (value) {});
  }

  String action = "create";
  setAction(String value) {
    action = value;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
