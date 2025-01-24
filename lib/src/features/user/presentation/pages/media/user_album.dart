import 'dart:typed_data';

import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

Future<AssetPathEntity?> showUserAlbumPopup(
    BuildContext context, List<AssetPathEntity> albums, WidgetRef ref) async {
  final controller = ref.watch(userMediaControllerProvider);

  if (albums.isEmpty) {
    return Future.value(null);
  }

  final List<Map<String, dynamic>> albumWithThumbnail = [];

  for (var album in albums) {
    final List<AssetEntity> assets =
        await album.getAssetListPaged(page: 1, size: 1);
    final AssetEntity? assetFirst = assets.isNotEmpty ? assets.first : null;
    int totalAssets = await album.assetCountAsync;
    albumWithThumbnail
        .add({"album": album, "first": assetFirst, "total": totalAssets});
  }

  print(">>>>>>>>>>albumLength: ${albumWithThumbnail}");

  return showMenu<AssetPathEntity>(
    color: Colors.white,
    context: context,
    constraints: BoxConstraints(minWidth: ScreenUtil().screenWidth),
    position: const RelativeRect.fromLTRB(100, 80, 100, 100),
    items: albumWithThumbnail.map((albumData) {
      final AssetPathEntity album = albumData["album"];
      final AssetEntity? assetFirst = albumData["first"];
      controller.setIsShowPopUp(true);

      return PopupMenuItem<AssetPathEntity>(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        onTap: () async => await controller.selectAlbum(album),
        value: album,
        child: ListTile(
          leading: assetFirst != null
              ? FutureBuilder<Uint8List?>(
                  future: assetFirst.thumbnailData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 64,
                        width: 64,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return SizedBox(
                        height: 64,
                        width: 64,
                        child:
                            Container(), // Hoặc một widget khác nếu không có dữ liệu
                      );
                    }
                  },
                )
              : SizedBox(
                  height: 64,
                  width: 64,
                  child:
                      Container(), // Hoặc một widget khác để hiển thị khi assetFirst là null
                ),
          title: Text(album.name),
          subtitle: Text("${albumData["total"]}"),
        ),
      );
    }).toList(),
  );
}
