import 'dart:io';

import 'package:app_tcareer/src/features/jobs/data/models/apply_job_model.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  Future<void> removeFile() async {
    selectedFile = null;
    notifyListeners();
  }

  Future<String?> uploadFile(BuildContext context) async {
    String? fileUrl;
    const uuid = Uuid();
    final id = uuid.v4();
    String? url = await jobUseCase.uploadFile(
        file: File(selectedFile?.path ?? ""),
        folderPath: "cv/$id",
        contentType: "application/pdf");
    if (url != "") {
      fileUrl = url;
    }

    return fileUrl;
  }

  Future<void> submitApplication(
      {required num jobId, required BuildContext context}) async {
    AppUtils.loadingApi(() async {
      String? fileUrl = await uploadFile(context);

      await jobUseCase.postSubmitApplication(
          body: ApplyJobModel(cvFile: fileUrl, jobId: jobId));
      showSnackBar("Bạn đã ứng tuyển thành công");
      selectedFile = null;
      fileName = null;
      context.pop();
    }, context);
  }
}

final applyJobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return ApplyJobController(jobUseCase);
});
