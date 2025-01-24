import 'dart:io';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/engagement_widget.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/widgets/photos/app_photo_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
  Future<void> downLoadImage(String imageUrl) async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      var status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
      print(">>>>>>>>status: $status");
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
      if (status.isGranted) {
        Directory? appDocDir = await getExternalStorageDirectory();
        String savePath =
            '${appDocDir!.path}/Pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
        print(">>>>>>>>>>>savePath: $savePath");
        final response = await dio.download(imageUrl, savePath);
        if (response.statusCode == 200) {
          final result = await ImageGallerySaver.saveFile(savePath);

          if (result != null) {
            showSnackBar("Tải ảnh về thành công");
          }
        } else {
          showSnackBarError("Tài ảnh về thất bại");
        }
      }
    } catch (e) {
      print(">>>>>>>$e");
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
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => context.pop(),
            ),
            automaticallyImplyLeading: false,
            titleTextStyle: const TextStyle(color: Colors.white),
            title: Visibility(
                visible: widget.data.images.length > 1,
                child: Text("${index + 1}/${widget.data.images.length}")),
            actions: [
              Visibility(
                visible:
                    widget.data.images.any((image) => image.isImageNetWork),
                child: IconButton(
                    onPressed: () async =>
                        await downLoadImage(widget.data.images[index]),
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PhotoViewGallery.builder(
                  pageController: pageController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    final assetSource = widget.data.images[index];
                    final isNetworkAsset = assetSource.isNetworkSource;
                    return PhotoViewGalleryPageOptions.customChild(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    );
                  },
                  itemCount: widget.data.images.length,
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
              const SizedBox(
                height: 10,
              ),
            ],
          ),
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
