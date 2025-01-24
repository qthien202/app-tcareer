import 'package:app_tcareer/src/widgets/shimmer_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget informationLoading() {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerLoadingWidget(
            child: Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          width: 200, // Độ rộng tạm của text
          height: 15, // Độ cao tương đương với text
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20)), // Màu skeleton
        )),
        const SizedBox(
          height: 5,
        ),
        shimmerLoadingWidget(
            child: Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          width: 120, // Độ rộng tạm của text
          height: 15, // Độ cao tương đương với text
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20)), // Màu skeleton
        )),
        const SizedBox(height: 10),
      ],
    ),
    subtitle: shimmerLoadingWidget(
        child: Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      width: 100, // Độ rộng tạm của text
      height: 15, // Độ cao tương đương với text
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20)), // Màu skeleton
    )),
    trailing: shimmerLoadingWidget(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey.shade200,
      ),
    ),
  );
}
