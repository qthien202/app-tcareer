import 'package:image_picker/image_picker.dart';

extension FileTypeChecker on XFile {
  bool isImage() {
    final fileExtension = name.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension);
  }

  bool isVideo() {
    final fileExtension = name.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(fileExtension);
  }
}
