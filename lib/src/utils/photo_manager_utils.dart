import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class PhotoManagerUtils {
  static Future<bool> requestPermission() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      return true;
    }
    PhotoManager.openSetting();
    return false;
  }

  static Future<List<AssetEntity>> pickMedia({int page = 0, int? size}) async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image | RequestType.video);
    AssetPathEntity album = albums.first;
    print(">>>>>>>>>>>>>>>albums: $albums");
    int totalAssets = await album.assetCountAsync;

    List<AssetEntity> assets =
        await albums.first.getAssetListPaged(page: page, size: totalAssets);
    print(">>>>>>>>>>>>>>>assets: $assets");
    return assets;
  }
}
