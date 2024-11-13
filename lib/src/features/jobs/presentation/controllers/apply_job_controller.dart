import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyJobController extends ChangeNotifier {
  File? selectedFile;
  String? fileName; // Khai báo biến để lưu tệp

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      fileName = result.files.single.name;
      print("File name: $fileName");

      selectedFile = File(result.files.single.path!);
      print("File path: ${selectedFile?.path}");
      notifyListeners();
    } else {
      // Người dùng hủy chọn tệp
    }
  }
}

final applyJobControllerProvider = ChangeNotifierProvider((ref) {
  return ApplyJobController();
});
