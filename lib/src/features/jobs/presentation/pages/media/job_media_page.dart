import 'dart:typed_data';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/create_job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_media_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/create_job/job_cty.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import 'job_album.dart';

class JobMediaPage extends ConsumerStatefulWidget {
  const JobMediaPage({super.key, this.isComment, this.content});
  final bool? isComment;
  final String? content;

  @override
  ConsumerState<JobMediaPage> createState() => _JobMediaPageState();
}

class _JobMediaPageState extends ConsumerState<JobMediaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ref.read(mediaControllerProvider).loadCache();
      ref.read(jobMediaControllerProvider).getAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(jobMediaControllerProvider);
    final createJobController = ref.watch(createJobControllerProvider);

    return PopScope(
      onPopInvoked: (didPop) async {
        context.pop();
        await createJobController.showBottomSheet(
            context: context, child: const JobCty());
      },
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

                return FutureBuilder<Uint8List?>(
                  future: item.thumbnailData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center();
                    }

                    return InkWell(
                        onTap: () async {
                          await controller.updateAvatar(
                              asset: item, context: context);
                        },
                        child: Container(
                            child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        )));
                  },
                );
              })),
    );
  }

  PreferredSize appBar() {
    final controller = ref.watch(userMediaControllerProvider);
    final createJobController = ref.watch(createJobControllerProvider);
    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              await createJobController.showBottomSheet(
                  context: context, child: const JobCty());
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            onTap: () async {
              if (controller.isShowPopUp != true) {
                await showJObAlbumPopup(context, controller.albums, ref);
              } else {
                controller.setIsShowPopUp(false);
              }
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
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                )),
          ],
        ));
  }
}
