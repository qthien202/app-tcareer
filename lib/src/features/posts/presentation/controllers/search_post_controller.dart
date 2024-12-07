import 'dart:convert';

import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart'
    as post;
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/search_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart' as user;
import 'package:app_tcareer/src/features/user/presentation/controllers/user_connection_controller.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPostController extends ChangeNotifier {
  final SearchUseCase searchUseCase;
  final PostUseCase postUseCase;
  final UserUtils userUtils;

  SearchPostController(this.searchUseCase, this.postUseCase, this.userUtils) {
    scrollController.addListener(() {
      loadMore();
    });
  }

  QuickSearchUserData quickSearchData = QuickSearchUserData();
  TextEditingController queryController = TextEditingController();
  final Debouncer debouncer = Debouncer(milliseconds: 1000);

  Future<void> quickSearchUser() async {
    quickSearchData =
        await searchUseCase.getQuickSearchUser(queryController.text);

    notifyListeners();
  }

  Future<void> onSearch() async {
    debouncer.run(() async {
      if (queryController.text.isNotEmpty) {
        await quickSearchUser();
      } else {
        quickSearchData.data?.clear();
        notifyListeners();
      }
    });
  }

  post.PostsResponse? postData;

  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String? queryCache;
  Future<void> search(String query) async {
    // postData = null;
    // posts.clear();
    page = 1;
    queryCache = query;
    setIsLoading(true);
    final data = await searchUseCase.getSearch(query);
    List<dynamic> userJson = data['users']['data'];
    mapUserFromJson(userJson);
    await searchPost();
    setIsLoading(false);
    setSearchHistory();
  }

  List<user.Data> users = [];
  Future<void> mapUserFromJson(List<dynamic> userJson) async {
    users = userJson
        .whereType<Map<String, dynamic>>()
        .map((item) => user.Data.fromJson(item))
        .toList();
  }

  List<post.Data> posts = [];
  int page = 1;
  Future<void> searchPost() async {
    postData =
        await searchUseCase.getSearchPost(query: queryCache ?? "", page: page);
    if (postData?.data != null) {
      final newPosts = postData?.data
          ?.where((newPost) =>
              !posts.any((cachedPost) => cachedPost.id == newPost.id))
          .toList();
      posts.addAll(newPosts as Iterable<post.Data>);
      notifyListeners();
    }
  }

  bool isLoadingMore = false;
  final ScrollController scrollController = ScrollController();
  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (!isLoadingMore && posts.length < (postData?.meta?.total ?? 0)) {
        isLoadingMore = true;

        try {
          page += 1;
          notifyListeners();
          await searchPost();
        } finally {
          isLoadingMore = false;
        }
      }
      await searchPost();
    }
  }

  // Future<void> mapPostFromJson(List<dynamic> postJson) async {
  //   posts = postJson
  //       .whereType<Map<String, dynamic>>()
  //       .map((item) => post.Data.fromJson(item))
  //       .toList();
  // }

  int pendingLikeCount = 0;
  bool isLikeProcess = false;
  Future<void> postLikePost({
    required int index,
    required String postId,
  }) async {
    if (isLikeProcess) return;
    isLikeProcess = true;
    final currentPost = posts[index];
    final isLiked = currentPost.liked ?? false;
    final likeCount = currentPost.likeCount ?? 0;
    pendingLikeCount = isLiked ? -1 : 1;
    final updatedPostTemp = currentPost.copyWith(
        liked: !(posts[index].liked ?? false),
        likeCount: likeCount + pendingLikeCount);

    posts[index] = updatedPostTemp;
    notifyListeners();
    // setLikePost(index);
    await postUseCase.postLikePost(
        postId: postId, index: index, postCache: posts);
    isLikeProcess = false;
    notifyListeners();
    pendingLikeCount = 0;
  }

  Future<void> refresh() async {
    page = 1;
    posts.clear();

    search(queryCache ?? "");
    // posts.clear();
    await searchPost();
  }

  Future<void> setSearchHistory() async {
    userUtils.removeCache("searchHistory");
    List<String>? loadedHistory =
        await userUtils.loadCacheList("searchHistory");
    if (searchHistory
        .any((e) => loadedHistory?.any((item) => item != e) == true)) {
      searchHistory.add(queryController.text);
      await userUtils.saveCacheList(
          key: "searchHistory", value: searchHistory.cast<String>());
    }
  }

  List<String> searchHistory = []; // Đảm bảo kiểu dữ liệu là List<String>
  Future<void> loadSearchHistory() async {
    List<String>? loadedHistory =
        await userUtils.loadCacheList("searchHistory");

    if (loadedHistory != null) {
      searchHistory =
          loadedHistory.reversed.toList(); // Đảo ngược danh sách nếu muốn
      notifyListeners(); // Cập nhật UI sau khi tải lịch sử
    }
  }

  // Future<void>addFriend(String userId)async{
  //   final connectionController = ref.watch(userConnectionControllerProvider);
  //   await connectionController.postAddFriend(userId);
  // }

  Future<void> removeSearchHistory(int index) async {
    searchHistory.removeAt(index);
    await userUtils.saveCacheList(key: "searchHistory", value: searchHistory);
    notifyListeners();
    await loadSearchHistory();
  }

  Future<void> clearSearchHistory() async {
    searchHistory.clear();
    notifyListeners();
    await userUtils.removeCache("searchHistory");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.removeListener(loadMore);
    scrollController.dispose();
    queryController.dispose();
  }
}
