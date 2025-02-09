import 'dart:io';
import 'package:app_tcareer/src/features/jobs/data/models/apply_job_model.dart';
import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:app_tcareer/src/features/jobs/domain/job_use_case.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
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
  Ref ref;
  ApplyJobController(this.jobUseCase, this.ref);
  File? selectedFile;
  String? fileName; // Khai báo biến để lưu tệp

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      fileName = result.files.single.name;

      // Kiểm tra định dạng file có phải PDF không
      if (!(fileName.toString().toLowerCase().endsWith('.pdf') == true)) {
        showSnackBarError("Vui lòng chọn tệp CV định dạng PDF.");
        return;
      }

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
        fileName: fileName,
        contentType: "application/pdf");
    if (url != "") {
      fileUrl = url;
    }

    return fileUrl;
  }

  bool? isApplied = false;
  Future<void> submitApplication(
      {required num jobId, required BuildContext context}) async {
    final jobController = ref.read(jobControllerProvider);
    final userController = ref.watch(userControllerProvider);
    String? cvFile = userController.userData?.data?.cvFile;
    AppUtils.loadingApi(() async {
      if (selectedFile != null) {
        cvFile = await uploadFile(context);
      }

      await jobUseCase.postSubmitApplication(
          body: ApplyJobModel(cvFile: cvFile, jobId: jobId));
      showSnackBar("Bạn đã ứng tuyển thành công");
      selectedFile = null;
      fileName = null;
      isApplied = true;
      jobController.getJobDetail(jobId.toString());
      jobController.refreshJob();
      jobController.refreshJobFavorites();
      context.pop();
      notifyListeners();
    }, context);
  }
}

final applyJobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return ApplyJobController(jobUseCase, ref);
});
