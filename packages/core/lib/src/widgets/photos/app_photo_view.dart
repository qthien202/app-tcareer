import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/src/extensions/image_extension.dart';
import 'package:core/src/extensions/video_extension.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/snackbar_utils.dart';
import '../video_fullscreen_widget.dart';
import '../../models/app_photo_model.dart';

class AppPhotoView extends StatefulWidget {
  final AppPhotoModel data;

  const AppPhotoView({super.key, required this.data});

  @override
  State<AppPhotoView> createState() => _AppPhotoViewState();
}

class _AppPhotoViewState extends State<AppPhotoView> {
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.data.index);
    });
  }

  int index = 0;
  void setIndex(int value) {
    setState(() {
      index = value;
    });
  }

  final Dio dio = Dio();
  Future<void> downloadMedia(String mediaUrl) async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      // Xin quyền (Android 13 trở xuống mới cần)
      var status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;

      if (!status.isGranted) {
        showSnackBarError("Không có quyền lưu trữ");
        return;
      }

      // Lấy đuôi file
      final isVideo = mediaUrl.toLowerCase().endsWith('.mp4');
      final ext = isVideo ? '.mp4' : '.jpg';

      // Chọn thư mục phù hợp
      Directory? dir;
      if (Platform.isAndroid) {
        dir = isVideo
            ? Directory('/storage/emulated/0/Movies') // Video
            : Directory('/storage/emulated/0/Pictures'); // Ảnh
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) {
        showSnackBarError("Không tìm được thư mục lưu trữ");
        return;
      }

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
      final savePath = '${dir.path}/$fileName';

      // Logger DIO
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));

      final response = await dio.download(mediaUrl, savePath);
      if (response.statusCode == 200) {
        final result = await ImageGallerySaver.saveFile(
          savePath,
          isReturnPathOfIOS: true,
        );

        if (result != null) {
          showSnackBar("📥 Đã lưu ${isVideo ? "video" : "ảnh"} vào thư viện");
        } else {
          showSnackBarError("❌ Lưu thất bại");
        }
      } else {
        showSnackBarError("❌ Tải file thất bại");
      }
    } catch (e) {
      print("❌ Lỗi tải media: $e");
      showSnackBarError("Đã xảy ra lỗi khi tải file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {},
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            bottomOpacity: 0,
            elevation: 0.0,
            // toolbarOpacity: 0.5,
            backgroundColor: Colors.black,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => context.pop(),
            ),
            automaticallyImplyLeading: false,
            titleTextStyle: const TextStyle(color: Colors.white),
            title: Visibility(
                visible: widget.data.medias.length > 1,
                child: Text("${index + 1}/${widget.data.medias.length}")),
            actions: [
              Visibility(
                visible: widget.data.medias
                    .any((media) => media.mediaUrl.isImageNetWork),
                child: IconButton(
                    onPressed: () async =>
                        await downloadMedia(widget.data.medias[index].mediaUrl),
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          body: PhotoViewGallery.builder(
              pageController: pageController,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                final media = widget.data.medias[index];
                final assetSource = media.mediaUrl;
                final isNetworkAsset = assetSource.isNetworkSource;
                return PhotoViewGalleryPageOptions.customChild(
                  child: Stack(
                    children: [
                      Visibility(
                        visible: !assetSource.isVideoNetWork,
                        replacement: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: VideoFullScreenWidget(assetSource)),
                        child: PhotoView(
                          imageProvider: isNetworkAsset
                              ? CachedNetworkImageProvider(assetSource)
                              : FileImage(File(assetSource)),
                          minScale: PhotoViewComputedScale.contained,
                          initialScale: PhotoViewComputedScale.contained,
                          heroAttributes:
                              PhotoViewHeroAttributes(tag: assetSource),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2), // Nền đen mờ
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(media.avatarUrl ?? ""),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        media.fullName ?? "",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        media.createdAt ?? "",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: widget.data.medias.length,
              loadingBuilder: (context, event) => const Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CupertinoActivityIndicator(
                          color: Colors.white, radius: 10),
                    ),
                  ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              // pageController: controller.pageController,
              onPageChanged: (val) {
                setIndex(val);
                widget.data.onPageChanged!(val);
              }),
          // bottomNavigationBar: BottomAppBar(
          //   color: Colors.black,
          //   child: engagementWidget(
          //       index: 1,
          //       liked: true,
          //       ref: ref,
          //       postId: postId,
          //       context: context,
          //       likeCount: "0",
          //       shareCount: "0"),
          // ),
        ),
      ),
    );
  }
}

extension ImageSourcePath on String {
  bool get isNetworkSource => startsWith('http://') || startsWith('https://');
}
