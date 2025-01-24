import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget postLoadingWidget(BuildContext context) {
  return SliverList(
    delegate: SliverChildBuilderDelegate((context, index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),

        // padding: const EdgeInsets.all(4),
        width: ScreenUtil().screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerLoadingWidget(
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 200, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 150, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 100, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth *
                            .7, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth *
                            .5, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                shimmerLoadingWidget(
                  child: cachedImageWidget(
                      imageUrl: "",
                      // height: ScreenUtil().screenHeight * .6,
                      width: ScreenUtil().screenWidth,
                      fit: BoxFit.cover),
                ),
                const SizedBox(
                  height: 10,
                ),
                shimmerLoadingWidget(
                    child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  width: 150, // Độ rộng tạm của text
                  height: 15, // Độ cao tương đương với text
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)), // Màu skeleton
                )),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      );
    }, childCount: 5),
  );
}

Widget postLoadingListViewWidget(BuildContext context) {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) {
      return Container(
        color: Colors.white,
        // padding: const EdgeInsets.all(4),
        width: ScreenUtil().screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerLoadingWidget(
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 200, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 150, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                  shimmerLoadingWidget(
                                      child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    width: 100, // Độ rộng tạm của text
                                    height: 15, // Độ cao tương đương với text
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(
                                            20)), // Màu skeleton
                                  )),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth *
                            .7, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                      shimmerLoadingWidget(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: ScreenUtil().screenWidth *
                            .5, // Độ rộng tạm của text
                        height: 15, // Độ cao tương đương với text
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20)), // Màu skeleton
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                shimmerLoadingWidget(
                  child: cachedImageWidget(
                      imageUrl: "",
                      // height: ScreenUtil().screenHeight * .6,
                      width: ScreenUtil().screenWidth,
                      fit: BoxFit.cover),
                ),
                const SizedBox(
                  height: 10,
                ),
                shimmerLoadingWidget(
                    child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  width: 150, // Độ rộng tạm của text
                  height: 15, // Độ cao tương đương với text
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)), // Màu skeleton
                )),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
