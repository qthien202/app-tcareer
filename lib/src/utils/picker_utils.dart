import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class PickerUtils {
  static Future<List<PickedImage>> pickImage() async {
    List<PickedImage> pickedImages = [];
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            pickedImages.add(PickedImage(
              bytes: file.bytes!,
              fileName: file.name,
            ));
          }
        }
      }
    } else {
      final ImagePicker picker = ImagePicker();
      List<XFile>? images = await picker.pickMultiImage();
      for (var image in images) {
        pickedImages.add(PickedImage(
          path: image.path,
          fileName: image.name,
        ));
      }
    }
    return pickedImages;
  }
}

class PickedImage {
  final String? path;
  final Uint8List? bytes;
  final String fileName;

  PickedImage({
    this.path,
    this.bytes,
    required this.fileName,
  });
}
