import 'dart:io';

import 'package:app_tcareer/src/features/authentication/usecases/login_use_case.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/jobs/data/models/add_job_topic_request.dart';
import 'package:app_tcareer/src/features/jobs/data/models/get_job_response.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/job_topic_model.dart';
import 'package:app_tcareer/src/features/jobs/data/models/topic_job_favorite_response.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post_model;
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/resume_model.dart';
import 'package:app_tcareer/src/features/user/data/models/update_profile_request.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/connection_use_case.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserController extends ChangeNotifier {
  final UserUseCase userUseCase;
  final PostUseCase postUseCase;
  final Ref ref;
  UserController(this.userUseCase, this.postUseCase, this.ref) {
    getUserInfo();
    getResume();
    getPost();
    getPostedJob();
    // scrollController.addListener(() {
    //   loadMore();
    // });
  }

  Users? userData;

  Future<void> getUserInfo() async {
    userData = await userUseCase.getUserInfo();
    setInfo();
    notifyListeners();
  }

  Users anotherUserData = Users();
  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Future<void> getUserById(String userId) async {
  //   print(">>>>>>>>>>>>userId:$userId");
  //   setIsLoading(true);
  //   anotherUserData = null;
  //   anotherUserData = await userUseCase.getUserById(userId);
  //   setIsLoading(false);
  //   notifyListeners();
  // }

  post_model.PostsResponse? postData;
  final ScrollController scrollController = ScrollController();
  List<post_model.Data> postCache = [];
  int page = 1;
  Future<void> getPost() async {
    postData = null;
    postData = await postUseCase.getPost(personal: "p", page: page);
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !postCache.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      postCache.addAll(newPosts as Iterable<post_model.Data>);
    }
    print(">>>>>>>>>postLength: ${postCache.length}");
    print(">>>>>>>>>>>>page: $page");
    notifyListeners();
  }

  bool isLoadingMore = false;
  Future<void> loadMore() async {
    // isLoadingMore = true;
    if (!isLoadingMore && postCache.length < (postData?.meta?.total ?? 0)) {
      isLoadingMore = true;
      try {
        page += 1;
        notifyListeners();
        await getPost();
      } finally {
        isLoadingMore = false; // Đặt lại trạng thái
      }
    }
  }

  int pendingLikeCount = 0;
  bool isLikeProcess = false;
  Future<void> postLikePost({
    required int index,
    required String postId,
  }) async {
    if (isLikeProcess) return;
    isLikeProcess = true;
    final currentPost = postCache[index];
    final isLiked = currentPost.liked ?? false;
    final likeCount = currentPost.likeCount ?? 0;
    pendingLikeCount = isLiked ? -1 : 1;
    final updatedPostTemp = currentPost.copyWith(
        liked: !(postCache[index].liked ?? false),
        likeCount: likeCount + pendingLikeCount);

    postCache[index] = updatedPostTemp;
    notifyListeners();
    // setLikePost(index);
    await postUseCase.postLikePost(
        postId: postId, index: index, postCache: postCache);
    isLikeProcess = false;
    notifyListeners();
    pendingLikeCount = 0;
  }

  Future<void> refresh() async {
    page = 1;
    // postData?.data?.clear();
    postData = null;
    postCache.clear();

    // notifyListeners();

    await getUserInfo();
    await getResume();
    await getPost();
  }

  Future<void> logout(BuildContext context) async {
    // var providers = ref.container.getAllProviderElements();
    final auth = ref.watch(loginUseCase);
    final connectUseCase = ref.watch(connectionUseCaseProvider);
    AppUtils.loadingApi(() async {
      await connectUseCase.setUserOfflineStatus();
      await auth.logout();

      // for (var element in providers) {
      //   element.invalidateSelf();
      // }
      context.goNamed("login");
    }, context);
  }

  bool isCurrentUser(int userId) {
    print(">>>>>>>>>>>isCurrent: ${userData?.data?.id == userId}");
    return userData?.data?.id == userId;
  }

  ResumeModel? resumeModel;
  Future<void> getResume() async {
    resumeModel = await userUseCase.getResume();
    print(
        ">>>>>>>>>>>>>>>>>>isEmpty: ${resumeModel?.data?.education?.isEmpty}");
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<JobModel> postedJobs = [];
  GetJobResponse? postedJobRes;
  int postedPage = 1;

  Future<void> getPostedJob() async {
    postedJobRes = await userUseCase.getPostedJob(page: postedPage);
    if (postedJobRes?.data != null) {
      final newJobs = postedJobRes?.data
          ?.where((newJob) => !postedJobs.any((job) => job.id == newJob.id))
          .toList();
      postedJobs.addAll(newJobs as Iterable<JobModel>);
      notifyListeners();
    }
  }

  Future<void> loadPostedJobMore(ScrollController scrollController) async {
    // if (scrollController.position.maxScrollExtent == scrollController.offset) {
    if (postedJobs.length < (postedJobRes?.meta?.total ?? 0)) {
      postedPage += 1;
      await getPostedJob();
    }
    // }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  setInfo() {
    final user = userData?.data;
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    emailController.text = user?.email ?? "";
    phoneController.text = user?.phone ?? "";
  }

  Future<void> updateProfile(BuildContext context) async {
    AppUtils.loadingApi(() async {
      await userUseCase.putUpdateProfile(
          body: UpdateProfileRequest(
              avatar: userData?.data?.avatar ?? "",
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              fullName:
                  "${firstNameController.text} ${lastNameController.text}",
              phone: phoneController.text));
      showSnackBar("Cập nhật thông tin thành công");
      await getUserInfo();
    }, context);
  }

  List<JobTopicModel> jobTopics = [];
  Future<void> getJobTopic() async {
    jobTopics.clear();
    jobTopics = await userUseCase.getJobTopic();
    notifyListeners();
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

  TopicJobFavoriteResponse? topicDaTa;

  Future<void> getJobTopicFavorite() async {
    topicDaTa = await userUseCase.getJobTopicFavorite();

    if (topicDaTa != null) {
      selectedTopics =
          topicDaTa?.data?.map((data) => data.topicId ?? 0).toList() ?? [];

      notifyListeners();
    }
  }

  Future<void> addJobTopic(BuildContext context) async {
    AppUtils.loadingApi(() async {
      await userUseCase.postAddJobTopic(
          body: AddJobTopicRequest(topicIds: selectedTopics));
      showSnackBar("Lưu thành công");
    }, context);
  }
}

final userControllerProvider = ChangeNotifierProvider((ref) {
  final userUseCase = ref.watch(userUseCaseProvider);
  final postUseCase = ref.watch(postUseCaseProvider);
  return UserController(userUseCase, postUseCase, ref);
});
