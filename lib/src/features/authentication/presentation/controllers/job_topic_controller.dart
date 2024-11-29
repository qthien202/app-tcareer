import 'package:app_tcareer/src/features/jobs/data/models/add_job_topic_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/topic_job_favorite_response.dart';
import 'package:app_tcareer/src/features/jobs/data/repository/job_repository.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobTopicController extends ChangeNotifier {
  JobRepository jobRepository;
  Ref ref;
  JobTopicController(this.jobRepository, this.ref);
  List<JobTopicModel> jobTopics = [];
  Future<void> getJobTopic() async {
    jobTopics.clear();
    jobTopics = await jobRepository.getJobTopic();
    notifyListeners();
  }

  Future<void> addJobTopic(BuildContext context) async {
    AppUtils.loadingApi(() async {
      await jobRepository.postAddJobTopic(
          body: AddJobTopicRequest(topicIds: selectedTopics));
      showSnackBar("Lưu thành công");
      context.goNamed("home");
    }, context);
  }

  List<num> selectedTopics = [];
  selectTopic(num topic) {
    if (selectedTopics.length == 5 && !selectedTopics.contains(topic)) {
      showSnackBarError("Bạn chỉ được chọn tối đa 5 lĩnh vực");
      return;
    }
    if (!selectedTopics.contains(topic)) {
      selectedTopics.add(topic);
      notifyListeners();
    } else {
      selectedTopics.remove(topic);
      notifyListeners();
    }
  }

  TopicJobFavoriteResponse? topicFavorites;
  Future<void> getTopicFavorite(BuildContext context) async {
    final jobRepository = ref.watch(jobRepositoryProvider);
    topicFavorites = await jobRepository.getTopicJobFavorite();
    notifyListeners();
  }

  Future<void> cancelSetTopic() async {
    final userUtils = ref.watch(userUtilsProvider);
    topicFavorites = null;
    await userUtils.saveCache(key: "topics", value: "null");
    notifyListeners();
  }
}

final jobTopicControllerProvider = ChangeNotifierProvider((ref) {
  final jobRepository = ref.read(jobRepositoryProvider);
  return JobTopicController(jobRepository, ref);
});
