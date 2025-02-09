import 'dart:async';
import 'dart:io';

import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:app_tcareer/src/features/user/domain/user_media_use_case.dart';
import 'package:app_tcareer/src/features/user/domain/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class UserMediaController extends ChangeNotifier {
  final UserMediaUseCase userMediaUseCase;
  final UserUseCase userUseCase;
  final Ref ref;
  UserMediaController(this.userMediaUseCase, this.userUseCase, this.ref);

  bool permissionGranted = false;
  List<AssetPathEntity> albums = [];
  List<AssetEntity> media = [];
  AssetPathEntity? selectedAlbum;

  bool isShowPopUp = false;

  void setIsShowPopUp(bool value) {
    isShowPopUp = value;
    notifyListeners();
  }

  Future<void> getAlbums() async {
    bool isPermission = await userMediaUseCase.requestPermission();

    if (isPermission) {
      albums = await userMediaUseCase.getAlbums(type: RequestType.image);
      selectedAlbum = albums.first;
      await getMediaFromAlbum(selectedAlbum!);
      notifyListeners();
    }
  }

  int albumSize = 18;
  Future<void> getMediaFromAlbum(AssetPathEntity album) async {
    media = await userMediaUseCase.getMediaFromAlbums(album: album);
    print(">>>>>>>>>>>>>>>>>>>>>2");
    notifyListeners();
  }

  Future<void> selectAlbum(album) async {
    selectedAlbum = album;
    await getMediaFromAlbum(selectedAlbum!);
    notifyListeners();
  }

  File? selectedImage;
  Future<void> selectImage(
      {required AssetEntity asset, required BuildContext context}) async {
    final file = await asset.file;
    if (file != null) {
      final croppedFile = await cropImage(image: file, context: context);
      if (croppedFile != null) {
        selectedImage = File(croppedFile.path);
        context.pop();
      }
      notifyListeners();
    }
  }

  Future<CroppedFile?> cropImage(
      {required File image, required BuildContext context}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          // toolbarTitle: 'Cropper',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          // title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),

            // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return croppedFile;
  }

  Future<void> updateAvatar(
      {required AssetEntity asset, required BuildContext context}) async {
    await selectImage(asset: asset, context: context);

    final user = ref.read(userControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    if (selectedImage != null) {
      AppUtils.futureApi(
        () async {
          final avatarUrl = await userMediaUseCase.uploadImage(
              file: selectedImage!, folderPath: "avatars/$id");
          await userUseCase.putUpdateProfile(
              body: UpdateProfileRequest(avatar: avatarUrl));
          // final currentUser = user.userData?.data;
          // final updatedUser = currentUser?.copyWith(avatar: avatarUrl);
          // user.userData = user.userData?.copyWith(data: updatedUser);
          await user.getUserInfo();
          showSnackBar("Cập nhật ảnh đại diện thành công");
        },
        context,
        (value) {},
      );
    }
  }
}

final userMediaControllerProvider = ChangeNotifierProvider((ref) =>
    UserMediaController(ref.read(userMediaUseCaseProvider),
        ref.read(userUseCaseProvider), ref));

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
