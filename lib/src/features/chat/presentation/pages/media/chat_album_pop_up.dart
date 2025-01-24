import 'dart:typed_data';

import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_media_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

Future<AssetPathEntity?> showChatAlbumPopup(
    BuildContext context, List<AssetPathEntity> albums, WidgetRef ref) async {
  final controller = ref.watch(chatMediaControllerProvider);

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
  controller.setIsShowPopUp(true);
  print(">>>>>>>>>>albumLength: ${albumWithThumbnail}");

  return showModalBottomSheet<AssetPathEntity>(
    context: context,
    isScrollControlled: false,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            controller.setIsShowPopUp(false);
          }
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  controller.setIsShowPopUp(false);
                  context.pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              title: Text(
                "Chọn album",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.zero,
              children: albumWithThumbnail.map((albumData) {
                final AssetPathEntity album = albumData["album"];
                final AssetEntity? assetFirst = albumData["first"];
                controller.setIsShowPopUp(true);

                return ListTile(
                  onTap: () async {
                    await controller.selectAlbum(album);
                    Navigator.pop(context,
                        album); // Đóng BottomSheet và trả về album đã chọn
                  },
                  leading: assetFirst != null
                      ? FutureBuilder<Uint8List?>(
                          future: assetFirst.thumbnailData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 64,
                                width: 64,
                                child:
                                    Center(child: CircularProgressIndicator()),
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
                );
              }).toList(),
            ),
          ),
        ),
      );
    },
  );
}
