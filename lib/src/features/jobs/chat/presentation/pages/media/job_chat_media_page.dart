import 'dart:typed_data';
import 'package:app_tcareer/src/features/chat/presentation/widgets/chat_bottom_app_bar.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/controllers/job_chat_controller.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/controllers/job_chat_media_controller.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/widgets/job_chat_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'job_chat_album_pop_up.dart';

class JobChatMediaPage extends ConsumerStatefulWidget {
  const JobChatMediaPage(
      {super.key,
      required this.scrollController,
      required this.draggableScrollableController});
  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;

  @override
  ConsumerState<JobChatMediaPage> createState() => _JobChatMediaPageState();
}

class _JobChatMediaPageState extends ConsumerState<JobChatMediaPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final controller = ref.read(jobChatMediaControllerProvider);
    widget.scrollController.addListener(() {
      Future.microtask(
        () async {
          if (widget.scrollController.position.maxScrollExtent ==
              widget.scrollController.offset) {
            await controller.loadMore();
          }
        },
      );
    });

    widget.draggableScrollableController.addListener(() {
      Future.microtask(() async {
        if (widget.draggableScrollableController.size == 1.0) {
          await controller.setIsMaxChildSizeMedia(true);
        } else {
          await controller.setIsMaxChildSizeMedia(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(jobChatMediaControllerProvider);

    return Scaffold(
        appBar: appBar(),
        body: ListView(
          controller: widget.scrollController,
          children: [
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                        ),
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                        ? Border.all(
                                            color: Colors.blue, width: 1)
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
                                              color: Colors.white,
                                              fontSize: 13),
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
                }),
          ],
        ));
  }

  PreferredSize appBar() {
    final controller = ref.watch(jobChatMediaControllerProvider);
    final chatController = ref.watch(jobChatControllerProvider);
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Visibility(
          visible: controller.isMaxChildSizeMedia == true,
          replacement: jobChatBottomAppBar(ref, context, autoFocus: false),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                chatController.setIsShowMedia(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            title: InkWell(
              onTap: () async {
                if (controller.isShowPopUp != true) {
                  await showJobChatAlbumPopup(context, controller.albums, ref);
                } else {
                  controller.setIsShowPopUp(false);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                child: GestureDetector(
                  onTap: () async {
                    await controller.getAssetPaths(context);
                    await controller.uploadMedia(context);
                    // if (mounted) {
                    // await chatController.sendMessageWithMedia(context);
                    // }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(
                        8), // Thêm padding để làm cho nút đẹp hơn
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
