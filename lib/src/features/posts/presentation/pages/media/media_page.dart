import 'dart:typed_data';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import 'show_album_pop_up.dart';

class MediaPage extends ConsumerStatefulWidget {
  const MediaPage({super.key, this.isComment, this.content});
  final bool? isComment;
  final String? content;

  @override
  ConsumerState<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends ConsumerState<MediaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mediaControllerProvider).loadCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(mediaControllerProvider);
    final postingController = ref.watch(postingControllerProvider);
    return BackButtonListener(
      onBackButtonPressed: () async {
        // postingController.setContent(widget.content);
        Future.delayed(Duration.zero, () {
          controller.resetAutoPop();
          controller.clearData(context);
        });
        return true;
      },
      // onPopInvoked: (didPop) {
      //   if (didPop) {
      //     Future.delayed(Duration.zero, () {
      //       controller.resetAutoPop();
      //       controller.clearData(context);
      //     });
      //   }
      // },
      child: Scaffold(
          appBar: appBar(),
          body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: controller.media.length,
              itemBuilder: (context, index) {
                final item = controller.media[index];

                Uint8List? cachedThumbnail =
                    controller.cachedThumbnails[item.id];
                return FutureBuilder<Uint8List?>(
                  future: cachedThumbnail != null
                      ? Future.value(cachedThumbnail)
                      : item.thumbnailData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center();
                    }

                    if (cachedThumbnail == null && snapshot.data != null) {
                      controller.cachedThumbnails[item.id] = snapshot.data!;
                    }

                    bool isSelected = controller.selectedAsset.contains(item);
                    int? selectedIndex = isSelected
                        ? controller.selectedAsset.indexOf(item) + 1
                        : null;
                    final duration = controller.cachedVideoDurations[item.id];
                    final formattedDuration = duration != null
                        ? '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
                        : "00:00";

                    return InkWell(
                      onTap: () async => await controller.addAsset(
                          asset: item,
                          context: context,
                          isComment: widget.isComment),
                      child: Container(
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 2.5)
                              : null,
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (item.type == AssetType.video)
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    formattedDuration,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                alignment: Alignment.center,
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  border: isSelected
                                      ? Border.all(color: Colors.blue, width: 1)
                                      : Border.all(
                                          color: Colors.white, width: 1),
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? Text(
                                        '$selectedIndex',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Text(
                                        '2',
                                        style: TextStyle(
                                            color: Colors.transparent,
                                            fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })),
    );
  }

  PreferredSize appBar() {
    final controller = ref.watch(mediaControllerProvider);
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              controller.resetAutoPop();
              controller.clearData(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            onTap: () async {
              if (controller.isShowPopUp != true) {
                await showAlbumPopup(context, controller.albums, ref);
              }
              controller.setIsShowPopUp(false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.selectedAlbum?.name ?? "",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Visibility(
                  visible: controller.albums.length >= 1,
                  child: Visibility(
                      visible: controller.isShowPopUp != true,
                      replacement: const Icon(Icons.keyboard_arrow_up),
                      child: const Icon(Icons.keyboard_arrow_down)),
                )
              ],
            ),
          ),
          actions: [
            Visibility(
              visible: controller.selectedAsset.isNotEmpty,
              replacement: IconButton(
                  onPressed: () async =>
                      await controller.pickImageCamera(context),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  )),
              child: TextButton(
                child: const Text(
                  "Hoàn tất",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => controller.getAssetPaths(context),
              ),
            )
          ],
        ));
  }
}
