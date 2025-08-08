import 'package:app_tcareer/src/features/posts/presentation/controllers/posting_controller.dart';
import 'package:flutter/material.dart';

import 'privacy_bottom_sheet_widget.dart';

Widget privacyWidget(PostingController controller, BuildContext context) {
  Map<String, dynamic> mapTitle = {
    "Public": "Công khai",
    "Friend": "Bạn bè",
    "Private": "Chỉ mình tôi"
  };

  Map<String, dynamic> privacyIcon = {
    "Public": Icons.public,
    "Friend": Icons.group,
    "Private": Icons.lock
  };
  return GestureDetector(
    onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => privacyBottomSheetWidget(context: context)),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade200),
      child: Row(
        children: [
          Icon(
            privacyIcon[controller.selectedPrivacy],
            size: 15,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            mapTitle[controller.selectedPrivacy],
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 15,
          ),
        ],
      ),
    ),
  );
}
