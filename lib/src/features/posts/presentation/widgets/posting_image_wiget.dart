import 'dart:io';
import 'package:app_tcareer/src/extensions/image_extension.dart';
import 'package:app_tcareer/src/features/posts/get_image_orientation.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/widgets/photos/app_photo_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget postingImageWidget(
    {required List<String> mediaUrl,
    required WidgetRef ref,
    bool visibleDelete = true}) {
  final controller = ref.watch(postingControllerProvider);
  if (mediaUrl.isEmpty) {
    return const SizedBox();
  }
  CarouselController carouselController = CarouselController();
  return Column(
    children: [
      CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: mediaUrl.length,
        itemBuilder: (context, index, realIndex) {
          String image = mediaUrl[index];

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Tính chiều cao dựa trên aspect ratio
                      double aspectRatio =
                          ref.watch(imageOrientationProvider(image)).when(
                                data: (orientation) =>
                                    orientation == ImageOrientation.landscape
                                        ? 1.91
                                        : 4 / 5,
                                loading: () => 16 / 9,
                                error: (error, stack) => 16 / 9,
                              );

                      return GestureDetector(
                        onTap: () {
                          final data = AppPhotoModel(
                              images: mediaUrl,
                              onPageChanged: (val) {
                                carouselController.animateToPage(
                                  val,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              index: index);
                          context.pushNamed("appPhoto", extra: data);
                        },
                        child: image.isImageNetWork
                            ? Image.network(
                                image,
                                width: constraints.maxWidth,
                                height: constraints.maxWidth / aspectRatio,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(image),
                                width: constraints.maxWidth,
                                height: constraints.maxWidth / aspectRatio,
                                fit: BoxFit.cover,
                              ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 15,
                top: 5,
                child: Visibility(
                  visible: visibleDelete,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(mediaControllerProvider).removeImage(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 1,
          aspectRatio: ref.watch(imageOrientationProvider(mediaUrl[0])).when(
                data: (orientation) =>
                    orientation == ImageOrientation.landscape ? 1.91 : 4 / 5,
                loading: () => 16 / 9, // Giá trị mặc định khi chưa tải xong
                error: (error, stack) => 16 / 9, // Giá trị mặc định khi có lỗi
              ), // Sử dụng aspect ratio đã tính toán
          onPageChanged: (index, reason) => controller.setActiveIndex(index),
        ),
      ),
      const SizedBox(height: 10),
      Center(
        child: AnimatedSmoothIndicator(
          count: mediaUrl.length,
          activeIndex: controller.activeIndex,
          effect: const ScrollingDotsEffect(
            dotWidth: 5,
            dotHeight: 5,
            activeDotColor: Colors.blue,
          ),
        ),
      ),
    ],
  );
}
