import 'dart:io';

import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ApplyJobController extends ChangeNotifier {
  JobUseCase jobUseCase;
  ApplyJobController(this.jobUseCase);
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

  Future<void> uploadFile(BuildContext context) async {
    const uuid = Uuid();
    final id = uuid.v4();
    AppUtils.loadingApi(() async {
      String? fileUrl = await jobUseCase.uploadFile(
          file: File(selectedFile?.path ?? ""),
          folderPath: "cv/$id",
          contentType: "application/pdf");
      if (fileUrl != "") {
        showSnackBar("Upload CV thành công");
      }
    }, context);
  }
}

final applyJobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return ApplyJobController(jobUseCase);
});
