import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_search_request.dart';
import 'package:app_tcareer/src/features/jobs/usecases/job_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchJobController extends ChangeNotifier {
  JobUseCase jobUseCase;
  SearchJobController(this.jobUseCase);

  final Debouncer deBouncer = Debouncer(milliseconds: 1000);
  GetJobResponse? jobRes;
  List<JobModel> jobs = [];
  TextEditingController queryController = TextEditingController();
  Future<void> getSearchJob() async {
    setIsLoading(true);
    jobRes = await jobUseCase.getSearchJob(
        query: JobSearchRequest(q: queryController.text));
    if (jobRes?.data != null) {
      final newJobs = jobRes?.data
          ?.where((newJob) => !jobs.any((job) => job.id == newJob.id))
          .toList();
      jobs.addAll(newJobs as Iterable<JobModel>);
      print(">>>>>>>>>>jobs: $jobs");
      setIsLoading(false);
      notifyListeners();
    }
  }

  Future<void> onSearch() async {
    deBouncer.run(() async {
      if (queryController.text.isNotEmpty) {
        await getSearchJob();
      } else {
        jobRes = null;
        jobs.clear();
        notifyListeners();
      }
    });
  }

  bool isLoading = false;
  setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
}

final searchJobControllerProvider = ChangeNotifierProvider((ref) {
  final jobUseCase = ref.read(jobUseCaseProvider);
  return SearchJobController(jobUseCase);
});
