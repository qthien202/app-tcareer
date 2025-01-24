import 'dart:io';

import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/photos/app_photo_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppImage extends ConsumerStatefulWidget {
  final List<String> images;
  const AppImage({super.key, required this.images});

  @override
  ConsumerState<AppImage> createState() => _AppImageState();
}

class _AppImageState extends ConsumerState<AppImage> {
  CarouselController carouselController = CarouselController();
  int index = 0;
  void setIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final image = widget.images[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    final data = AppPhotoModel(
                        images: widget.images,
                        onPageChanged: (val) {
                          setIndex(val);
                          carouselController.animateToPage(
                            val,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        index: index);
                    context.pushNamed("appPhoto", extra: data);
                  },
                  child: Hero(
                    tag: image,
                    child: Visibility(
                      visible: image.isImageNetWork,
                      replacement: Image.file(
                        File(image),
                        width: ScreenUtil().screenWidth,
                        fit: BoxFit.cover,
                      ),
                      child: cachedImageWidget(
                        imageUrl: image,
                        width: ScreenUtil().screenWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
              aspectRatio: ref
                  .watch(imageOrientationProvider(widget.images[0]))
                  .when(
                    data: (orientation) =>
                        orientation == ImageOrientation.landscape
                            ? 1.91
                            : 4 / 5,
                    loading: () => 16 / 9, // Giá trị mặc định khi chưa tải xong
                    error: (error, stack) =>
                        16 / 9, // Giá trị mặc định khi có lỗi
                  ),
              initialPage: 0,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setIndex(index);
              }),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: widget.images.length > 1,
          child: Center(
            child: AnimatedSmoothIndicator(
              count: widget.images.length,
              activeIndex: index,
              effect: const ScrollingDotsEffect(
                dotWidth: 5,
                dotHeight: 5,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
